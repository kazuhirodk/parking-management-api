# Parking Management API

This is a Ruby on Rails project that implements a parking flow management.

## Documentation

### Technologies

**Ruby** 2.7.2 \
**Rails** 6.0.3 \
**PostgreSQL** 13.1


### Project setup
Configuration instructions for running the project locally are available [here](INSTALL.md)

## API Endpoints

### Entrance

#### Request
```
POST /api/v1/parking

{ plate: 'FAA-1234' }
```
#### Response
Must return a "ticket number" and validate **AAA-9999** mask

### Exit

#### Request
```
PUT /api/v1/parking/:id/out
```

### Payment

#### Request
```
PUT /api/v1/parking/:id/pay
```

### History

#### Request
```
GET /api/v1/parking/:plate
```
#### Response
```
[
  { id: 42, time: '25 minutes', paid: true, left: false }
]
```
## Run specs
```
source dev.sh
dkexec rspec
```
