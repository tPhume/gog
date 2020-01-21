package main

import (
	"github.com/gin-gonic/gin"
	"io"
	"log"
	"os"
)

func main() {
	router := gin.New()
	router.Use(gin.Logger(), gin.LoggerWithWriter(getLogFile("./log/basic.log")), gin.Recovery())
	router.GET("/", root)
	router.GET("/hello", hello)
	log.Fatal(router.Run("0.0.0.0:8080"))
}

func root(c *gin.Context) {
	c.JSON(200, gin.H{
		"message": "this is root",
	})
}

func hello(c *gin.Context) {
	c.JSON(200, gin.H{
		"message": "this is hello",
	})
}

func getLogFile(filename string) io.Writer {
	file, err := os.OpenFile(filename, os.O_RDWR|os.O_CREATE, 0644)
	if err != nil {
		log.Println("Using Stdout instead")
		return os.Stdout
	}

	return file
}
