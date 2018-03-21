# KSD RESTful API

### Build sqlite database
See *build_database.sh* for detail

### Run RESTful API locally (need to install Go)
```
mkdir API
export GOPATH=`pwd`/API/
go get github.com/bioxfu/go-ksd
go run API/src/github.com/bioxfu/go-ksd/main.go
```

### Run RESTful API in docker container (need to install Docker)
```
sudo ./build_image.sh
sudo ./run_image.sh
```

### API usage
- http://localhost:8080/v1/psite/:protein_id
- http://localhost:8080/v1/domain/:protein_id
- http://localhost:8080/v1/description/:protein_id
- http://localhost:8080/v1/alias/:gene_id
- http://localhost:8080/v1/GO/:gene_id

### Examples
- http://localhost:8080/v1/psite/AT1G01050.1
- http://localhost:8080/v1/domain/AT1G01050.1
- http://localhost:8080/v1/description/AT1G01050.1
- http://localhost:8080/v1/alias/AT1G01050
- http://localhost:8080/v1/GO/AT1G01050



