# Maze App

### Principal Feature
- List Shows
- Search for a show
- Favorite Shows
- Saving Favorite
- Deleting Favorite
- Sorting Favorite
- Serie Detail
- Episode Detail

##### Additional Features
- Added my DependencyInjector to make injection cleaner, and testability easier
- Xcodegen to not have .pbxproj merge
- Unit Tests:
  - Episode Scene
  - Favorite Shows Scene
  - Api
 
  ##### Pods
- Snapkit to make constraints easier

## _Setup_
- install cocoapods: sudo gem install cocoapods
- install xcodegen: brew install xcodegen  
- in terminal run: make generate
- or if you want to do manually you can run:
- xcodegen -q -s project.yml & pod install


