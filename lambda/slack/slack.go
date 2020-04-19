package slack

import (
	"bytes"
	"encoding/json"
	"fmt"
	"net/http"
)

type SlackMessage struct {
	Text        string       `json:"text"`
	Attachments []Attachment `json:"attachments"`
}

type Attachment struct {
	Text  string `json:"text"`
	Color string `json:"color"`
	Title string `json:"title"`
}

func BuildSlackMessage(resp http.Response, siteUrl string) SlackMessage {
	return SlackMessage{
		Text: fmt.Sprintf("`%s` failed with `%d` status code", siteUrl, resp.StatusCode),
		Attachments: []Attachment{
			Attachment{
				Text:  resp.Status,
				Color: "danger",
				Title: "Status",
			},
		},
	}
}

func PostToSlack(message SlackMessage, webhookUrl string) error {
	client := &http.Client{}
	data, err := json.Marshal(message)
	if err != nil {
		return err
	}

	req, err := http.NewRequest("POST", webhookUrl, bytes.NewBuffer(data))
	if err != nil {
		return err
	}

	resp, err := client.Do(req)
	if err != nil {
		return err
	}
	defer resp.Body.Close()

	if resp.StatusCode != 200 {
		fmt.Println(resp.StatusCode)
		return err
	}

	return nil
}
