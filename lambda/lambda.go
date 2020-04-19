package main

import (
	"fmt"
	"github.com/aws/aws-lambda-go/lambda"
	log "github.com/sirupsen/logrus"
	"gopkg.in/alecthomas/kingpin.v2"
	"lambda/slack"
	"net/http"
	"os"
	"strings"
)

var (
	app             = kingpin.New("main", "Uptime Monitor")
	inCli           = app.Flag("cli", "Whether to run Uptime Monitor as a CLI tool").Default("true").Envar("RUN_CLI").Bool()
	inLambda        = app.Flag("runLambda", "Whether to run the Lambda portions of Speedtrap (which will post messages to Slack").Default("false").Envar("RUN_LAMBDA").Bool()
	sites           = app.Flag("sites", "Site URLs to check").Envar("SITES").String()
	slackWebHookURL = app.Flag("slackWebHookURL", "Slack webhook URL").Envar("SLACK_WEBHOOK_URL").String()
)

func LambdaHandler() {
	log.Debugf("Requesting")

	for _, site := range strings.Split(*sites, ",") {
		resp, err := http.Get(site)

		if err != nil {
			log.Errorf("Error: %+v", err)
		} else {
			if resp.StatusCode != 200 {
				message := slack.BuildSlackMessage(*resp, site)
				slack.PostToSlack(message, *slackWebHookURL)
			}
		}
		log.Debugf("Request finished.")
	}
}

func main() {
	kingpin.Version("0.1")
	kingpin.MustParse(app.Parse(os.Args[1:]))

	if *inCli {
		fmt.Printf("Starting CLI...\n\n")
		LambdaHandler()
	}

	if *inLambda {
		fmt.Printf("Starting Lambda function...\n\n")
		lambda.Start(LambdaHandler)
	}
}
