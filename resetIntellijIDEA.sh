#CONFIG_FOLDER=".IntelliJIdea2019.3/config"
CONFIG_FOLDER=".config/JetBrains/IntelliJIdea2020.3"
rm -rf ~/$CONFIG_FOLDER/eval
rm -rf ~/$CONFIG_FOLDER/config/options/other.xml #(if exists)
#sed -i -E 's/<property name=\"evl.*\".*\/>//' ~/.config/JetBrains/DataGrip2021.1/options/other.xml
rm -rf ~/.java/.userPrefs/jetbrains/idea
