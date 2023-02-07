<img src="https://user-images.githubusercontent.com/26052609/217167915-de6ccfbd-1eaf-4f3f-a0cb-60a4f2b09de5.png" width="300" height="600" /> <img src="https://user-images.githubusercontent.com/26052609/217166392-f59cc532-4322-4c75-98f4-4ca3383b3273.png" width="300" height="600" /> <img src="https://user-images.githubusercontent.com/26052609/217167186-b88ca870-1e67-4cae-9461-d84860dc7e34.png" width="300" height="600" />
<img src="https://user-images.githubusercontent.com/26052609/217167272-7f469132-de9c-48c5-a52f-17646834fd16.png" width="300" height="600" />
<img src="https://user-images.githubusercontent.com/26052609/217167375-9f969d6d-bf16-4258-baa4-3d097514710d.png" width="300" height="600" />
<img src="https://user-images.githubusercontent.com/26052609/217167441-147a748c-c446-4682-b140-e4323fbc3683.png" width="300" height="600" />


# location-based-social-app-native

Frontend of location base social app

---
## Requirements

For development, you will need flutter installed

## Install

    $ git clone git@github.com:chinazhangyujia/location-based-social-app-flutter.git
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
