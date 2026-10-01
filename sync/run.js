#!/usr/bin/env node
'use strict';

const https = require('node:https');
const fs = require('node:fs');
const os = require('node:os');
const path = require('node:path');
const crypto = require('node:crypto');

// Добавляйте задачи здесь. source — путь от корня репозитория, dest — локальный путь.
const TASKS = [
	{ action: 'PULL', source: 'sync/.bash/.bash_custom_aliases', dest: '~/.bash/.bash_custom_aliases', name: 'Алиасы' },
	{ action: 'PULL', source: 'sync/.bash/.bash_custom_completions', dest: '~/.bash/.bash_custom_completions', name: 'Автодополнение' },
	{ action: 'PULL', source: 'sync/.bash/.bash_custom_env', dest: '~/.bash/.bash_custom_env', name: 'Переменные окружения' },
	{ action: 'PULL', source: 'sync/.bash/.bash_custom_methods', dest: '~/.bash/.bash_custom_methods', name: 'Функции Bash' },
	{ action: 'APPEND', source: 'sync/bashrc_imports.sh', dest: '~/.bashrc', name: 'Подключение к Bash' },
];

const REPOSITORY = 'strukovd/scripts-collection';
const BRANCH = 'master';
const MAX_FILE_BYTES = 5 * 1024 * 1024;
const REQUEST_TIMEOUT_MS = 15000;

class Helpers {
	// static ensureDir(p) {
	// 	fs.mkdirSync(p, { recursive: true });
	// 	console.log(`📁 Созданы новые директории: ${p}`);
	// }

	// static ensureFile(filePath, content = '') {
	// 	// Если файл не существует
	// 	if (!fs.existsSync(filePath)) {
	// 		const dirname = path.dirname(filePath);
	// 		this.ensureDir(dirname);
	// 		fs.writeFileSync(filePath, content, 'utf-8');
	// 		console.log(`📄 Файл успешно создан: ${filePath}`);
	// 	}
	// }

	// static userDir(p) {
	// 	const home = os.homedir();
	// 	if(typeof p !== 'string') return home;

	// 	p = p.trim();
	// 	if( path.isAbsolute(p) ) return p;

	// 	p = p.replace(/^~/, '');
	// 	return path.join(home, p);
	// }

	// static openDiff(remoteContent, absoluteDest) {
	// 	const tmpFile = `remote_${crypto.randomBytes(4).toString('hex')}_${path.basename(absoluteDest)}`;
	// 	const tmpPath = path.join(os.tmpdir(), tmpFile);
	// 	fs.writeFileSync(tmpPath, remoteContent, 'utf-8');

	// 	try {
	// 		execSync(`code --diff "${tmpPath}" "${absoluteDest}"`, { stdio: 'inherit' });
	// 		console.log(`💻 Окно сравнения открыто в VS Code.`);
	// 	} catch (codeError) {
	// 		console.error(`❌ Ошибка: Убедитесь, что VS Code установлен и команда 'code' доступна в терминале.`);
	// 	}
	// }

	static fetchGithubFile(pathToFile) {
		return new Promise((resolve, reject) => {
			const url = path.join(`https://raw.githubusercontent.com`, REPOSITORY, BRANCH, pathToFile); //`https://raw.githubusercontent.com/${REPOSITORY}/${BRANCH}/${pathToFile}`;
			const headers = { 'User-Agent': 'scripts-collection-sync' };

			// Скачиваем файл
			const request = https.get(url, headers, (response) => {
				if (response.statusCode !== 200) {
					response.resume();
					reject(new Error(`HTTP ${response.statusCode}: ${url}`));
					return;
				}
				const chunks = [];
				let size = 0;

				response.on('data', (chunk) => {
					size += chunk.length;
					if (size > MAX_FILE_BYTES) {
						request.destroy(new Error(`Файл больше ${MAX_FILE_BYTES} байт: ${url}`));
						return;
					}
					chunks.push(chunk);
				});
				response.on('end', () => resolve(Buffer.concat(chunks)));
				response.on('error', reject);
			});
			request.setTimeout(REQUEST_TIMEOUT_MS, () => request.destroy(new Error(`Истекло время ожидания: ${url}`)));
			request.on('error', reject);
		});
	}


// --

	static readLocal(file) {
		try {
			const info = fs.lstatSync(file);
			if (!info.isFile()) throw new Error(`Цель не является обычным файлом: ${file}`);
			return { content: fs.readFileSync(file), mode: info.mode & 0o777 };
		} catch (error) {
			if (error.code === 'ENOENT') return null;
			throw error;
		}
	}

	static backup(file) {
		const backupPath = `${file}.sync-backup-${new Date().toISOString().replace(/[:.]/g, '-')}-${crypto.randomBytes(4).toString('hex')}`;
		fs.copyFileSync(file, backupPath, fs.constants.COPYFILE_EXCL);
		return backupPath;
	}

	static writeAtomic(file, content, mode) {
		fs.mkdirSync(path.dirname(file), { recursive: true });
		const temp = path.join(path.dirname(file), `.${path.basename(file)}.sync-${crypto.randomBytes(8).toString('hex')}`);
		try {
			fs.writeFileSync(temp, content, { flag: 'wx', mode });
			fs.chmodSync(temp, mode);
			fs.renameSync(temp, file);
		} finally {
			try { fs.unlinkSync(temp); } catch (error) { if (error.code !== 'ENOENT') throw error; }
		}
	}

	static managedContent(local, remote, task) {
		const start = `# >>> MY_SYNC_BLOCK: ${task.source} >>>`;
		const end = `# <<< MY_SYNC_BLOCK: ${task.source} <<<`;
		const body = remote.toString('utf8').replace(/\r?\n+$/, '');
		const block = `${start}\n${body}\n${end}`;
		const startAt = local.indexOf(start);
		const endAt = local.indexOf(end);

		if ((startAt === -1) !== (endAt === -1) ||
			(startAt !== -1 && (endAt < startAt || local.indexOf(start, startAt + start.length) !== -1 || local.indexOf(end, endAt + end.length) !== -1))) {
			throw new Error(`Повреждены или повторяются маркеры блока в ${task.dest}`);
		}
		if (startAt !== -1) return local.slice(0, startAt) + block + local.slice(endAt + end.length);

		if (task.action === 'APPEND') {
			const separator = local && !local.endsWith('\n') ? '\n' : '';
			return `${local}${separator}${block}\n`;
		}
		return `${block}\n${local ? '\n' : ''}${local}`;
	}
}

class CLI { // Методы касаемо работы с CLI
	static main() {

	}

	static help() {

	}
}

// class Exec { // Обработчики
// 	static pull() {

// 	}

// 	static append() {

// 	}

// 	static prepend() {

// 	}
// }

class App {
	static parseArgs(args) {
		const options = { dryRun: false, force: false };
		for (const arg of args) {
			if (arg === '--dry-run') options.dryRun = true;
			else if (arg === '--force') options.force = true;
			else if (arg === '--help' || arg === '-h') options.help = true;
			else throw new Error(`Неизвестный аргумент: ${arg}`);
		}
		return options;
	}

	static async run(args = process.argv.slice(2), fetchFile = Helpers.download) {
		const options = this.parseArgs(args);
		if (options.help) {
			console.log('Использование: node [--dry-run] [--force]\n  --dry-run  показать план без записи\n  --force    заменить отличающиеся PULL-файлы с резервной копией');
			return 0;
		}

		let failures = 0;
		let conflicts = 0;
		for (const task of TASKS) {
			try {
				const result = await this.runTask(task, options, fetchFile);
				console.log(`${task.name}: ${result}`);
				if (result.includes('локальные отличия')) conflicts++;
			} catch (error) {
				failures++;
				console.error(`${task.name}: ошибка: ${error.message}`);
			}
		}
		console.log(`Готово. Ошибок: ${failures}; конфликтов: ${conflicts}.`);
		return failures || conflicts ? 1 : 0;
	}

	static async runTask(task, options, fetchFile = Helpers.download) {
		if (!['PULL', 'APPEND', 'PREPEND'].includes(task.action)) {
			throw new Error(`Неизвестное действие: ${task.action}`);
		}
		const file = Helpers.destination(task.dest);
		const remote = await fetchFile(Helpers.getSourceUrl(task.source));
		const local = Helpers.readLocal(file);

		if (task.action === 'PULL') return this.execPull(file, local, remote, options);
		return this.execInject(task, file, local, remote, options);
	}

	static execPull(file, local, remote, options) {
		if (local && local.content.equals(remote)) return 'без изменений';
		if (local && !options.force) return 'есть локальные отличия, пропущено (для замены: --force)';
		return this.save(file, local, remote, options);
	}

	static execInject(task, file, local, remote, options) {
		const current = local ? local.content.toString('utf8') : '';
		const next = Buffer.from(Helpers.managedContent(current, remote, task));
		if (local && local.content.equals(next)) return 'без изменений';
		return this.save(file, local, next, options);
	}

	static save(file, local, next, options) {
		if (options.dryRun) return local ? 'будет обновлен с резервной копией' : 'будет создан';
		const backupPath = local ? Helpers.backup(file) : null;
		Helpers.writeAtomic(file, next, local ? local.mode : 0o600);
		return backupPath ? `обновлен; резервная копия: ${backupPath}` : 'создан';
	}
}

if (require.main === module || module.id === '[stdin]') {
	App.run()
		.then((code) => { process.exitCode = code; })
		.catch((error) => {
			console.error(`Ошибка: ${error.message}`);
			process.exitCode = 1;
		});
}

module.exports = { App, Helpers };
