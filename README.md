# location_based_social_app  

This is frontend repo for this project  

Test in simulator:  
# start simulator  
open -a Simulator  
# build and run project in simulator (make sure backend is running)  
flutter run  


Description of folders:  
/dummy_data: json data used to test frontend independently with backend  
/exception: custom defined exception  
/model: classes that represent data fetched from backend server. Basically api call -> json -> instance of classes in this folder  
/provider: global status store for all the data that fetched from backend. Widgets will listen to the change of fields in these   classes. Update of fields will trigger rerender. The access layer of service call  
/screen: screens. Currently the style of screens are from material.dart which means ISO and Android will have same style  
/widget: shared widgets  
