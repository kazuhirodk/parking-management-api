# [DOCKER] Parking Management API Setup Instructions

## Clone repository
```
git clone git@github.com:kazuhirodk/parking-management-api.git
cd parking-management-api
```

## Install
Run helper script
```
source dev.sh
```
Build the project
```
dkbuild
```
Create databases and run migrations
```
dbsetup
```
Run application
```
dkupa
```

Application is running on http://localhost:3000
