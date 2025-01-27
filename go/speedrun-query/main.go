package main

import (
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"os"
	"time"
)

type SpeedrunCom struct {
	Data struct {
		Weblink   string `json:"weblink"`
		Game      string `json:"game"`
		Category  string `json:"category"`
		Level     any    `json:"level"`
		Platform  any    `json:"platform"`
		Region    any    `json:"region"`
		Emulators any    `json:"emulators"`
		VideoOnly bool   `json:"video-only"`
		Timing    string `json:"timing"`
		Values    struct {
		} `json:"values"`
		Runs []struct {
			Place int `json:"place"`
			Run   struct {
				ID       string `json:"id"`
				Weblink  string `json:"weblink"`
				Game     string `json:"game"`
				Level    any    `json:"level"`
				Category string `json:"category"`
				Videos   struct {
					Links []struct {
						URI string `json:"uri"`
					} `json:"links"`
				} `json:"videos"`
				Comment any `json:"comment"`
				Status  struct {
					Status     string    `json:"status"`
					Examiner   string    `json:"examiner"`
					VerifyDate time.Time `json:"verify-date"`
				} `json:"status"`
				Players []struct {
					Rel string `json:"rel"`
					ID  string `json:"id"`
					URI string `json:"uri"`
				} `json:"players"`
				Date      string    `json:"date"`
				Submitted time.Time `json:"submitted"`
				Times     struct {
					Primary          string `json:"primary"`
					PrimaryT         int    `json:"primary_t"`
					Realtime         any    `json:"realtime"`
					RealtimeT        int    `json:"realtime_t"`
					RealtimeNoloads  any    `json:"realtime_noloads"`
					RealtimeNoloadsT int    `json:"realtime_noloads_t"`
					Ingame           string `json:"ingame"`
					IngameT          int    `json:"ingame_t"`
				} `json:"times"`
				System struct {
					Platform string `json:"platform"`
					Emulated bool   `json:"emulated"`
					Region   any    `json:"region"`
				} `json:"system"`
				Splits any `json:"splits"`
				Values struct {
					Six8K7Yjql string `json:"68k7yjql"`
				} `json:"values"`
			} `json:"run"`
		} `json:"runs"`
	} `json:"data"`
}

type User struct {
	Data struct {
		ID    string `json:"id"`
		Names struct {
			International string      `json:"international"`
			Japanese      interface{} `json:"japanese"`
		} `json:"names"`
		SupporterAnimation bool        `json:"supporterAnimation"`
		Pronouns           interface{} `json:"pronouns"`
		Weblink            string      `json:"weblink"`
		NameStyle          struct {
			Style     string `json:"style"`
			ColorFrom struct {
				Light string `json:"light"`
				Dark  string `json:"dark"`
			} `json:"color-from"`
			ColorTo struct {
				Light string `json:"light"`
				Dark  string `json:"dark"`
			} `json:"color-to"`
		} `json:"name-style"`
		Role     string    `json:"role"`
		Signup   time.Time `json:"signup"`
		Location struct {
			Country struct {
				Code  string `json:"code"`
				Names struct {
					International string      `json:"international"`
					Japanese      interface{} `json:"japanese"`
				} `json:"names"`
			} `json:"country"`
		} `json:"location"`
		Twitch struct {
			URI string `json:"uri"`
		} `json:"twitch"`
		Hitbox  interface{} `json:"hitbox"`
		Youtube struct {
			URI string `json:"uri"`
		} `json:"youtube"`
		Twitter       interface{} `json:"twitter"`
		Speedrunslive interface{} `json:"speedrunslive"`
		Assets        struct {
			Icon struct {
				URI interface{} `json:"uri"`
			} `json:"icon"`
			SupporterIcon interface{} `json:"supporterIcon"`
			Image         struct {
				URI interface{} `json:"uri"`
			} `json:"image"`
		} `json:"assets"`
		Links []struct {
			Rel string `json:"rel"`
			URI string `json:"uri"`
		} `json:"links"`
	} `json:"data"`
}

func getInfos(url string) string {
	client := http.DefaultClient
	req, err := http.NewRequest("GET", url, nil)
	if err != nil {
		fmt.Println("Couldn't communicate with the API")
	}
	resp, err := client.Do(req)
	if err != nil {
		fmt.Println("Unable to get a response")
	}
	defer resp.Body.Close()
	content, err := io.ReadAll(resp.Body)
	if err != nil {
		fmt.Println("Unable to read content")
	}
	return string(content)
}

func (id *SpeedrunCom) getUser(p int) string { // Effectuer le traitement et query l'information souhaitée dans cette fonction avec un argument (ex: nom, pays, etc...)
	client := http.DefaultClient
	req, err := http.NewRequest("GET", "https://www.speedrun.com/api/v1/users/"+id.Data.Runs[p].Run.Players[0].ID, nil)
	if err != nil {
		fmt.Println("Couldn't communicate with the API")
	}
	resp, err := client.Do(req)
	if err != nil {
		fmt.Println("Unable to get a response")
	}
	defer resp.Body.Close()
	content, err := io.ReadAll(resp.Body)
	if err != nil {
		fmt.Println("Unable to read content")
	}
	return string(content)
}

func topTen() {
	var spdcom SpeedrunCom
	var user User
	for i := 0; i < 9; i++ {
		err := json.Unmarshal([]byte(getInfos(os.Args[1])), &spdcom)
		if err != nil {
			fmt.Printf("Could not parse %d JSON...\n", err)
		}
		err = json.Unmarshal([]byte(spdcom.getUser(i)), &user)
		if err != nil {
			fmt.Printf("Could not parse %d JSON...\n", err)
		}
		fmt.Printf("%v. %v ",
			i+1,
			spdcom.getUser(i),
		)
		for j := 0; j < 9; j++ {
			fmt.Printf("%s %s ",
				user.Data.Location.Country.Names.International,
				user.Data.Names.International,
			)
		}
	}
}

func main() {
	for true {
		topTen()
		time.Sleep(1 * time.Minute)
		fmt.Println("")
	}
}

// DS3 Any% Glitchless : "https://www.speedrun.com/api/v1/leaderboards/k6qg0xdg/category/jdz6v9v2"
