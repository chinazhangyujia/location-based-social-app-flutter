# location-based-social-app-native

Frontend of location base social app

---
## Requirements

For development, you will need flutter installed

## Install

    $ git clone git@gitlab.com:gcyz/location-based-social-app-native.git
    $ cd location-based-social-app-native
    $ flutter pub get

## Configure app

In lib/util/config.dart use dev service url

## Running the project

    $ flutter run

## Description of each folder

    - /dummy_data: json data used to test frontend independently with backend  
    - /exception: custom defined exception  
    - /model: classes that represent data fetched from backend server. Basically api call -> json -> instance of classes in this folder  
    - /provider: global status store for all the data that fetched from backend. Widgets will listen to the change of fields in these classes. Update of fields will trigger rerender. The access layer of service call  
    - /screen: screens. Currently the style of screens are from material.dart which means iOS and Android will have same style  
    - /widget: shared widgets  
