package main

import (
	"bufio"
	"fmt"
	"os"
	"regexp"
	"strings"
)

// parses .def files into swagger.yaml data100 definition field

type fileList struct {
	Crop string
	Cult string
	Fert string
	Fire string
	Fix  string
	Graz string
	Harv string
	Irri string
	Omad string
	Site string
	Tree string
	Trem string
}

func openFile(fileName string) []string {
	dstDir := string(fileName)
	readFile, err := os.Open(dstDir)
	if err != nil {
		fmt.Println(err)
		fmt.Println("error opening " + fileName + ", try absolute path")
	}
	fileScanner := bufio.NewScanner(readFile)
	fileScanner.Split(bufio.ScanLines)
	var fileTextLines []string
	for fileScanner.Scan() {
		fileTextLines = append(fileTextLines, fileScanner.Text())
	}
	readFile.Close()

	return fileTextLines
}

func handle(lines []string) ([]string, []string, []string, []string) {
	var description []string
	var descriptionLine string
	var fmtKeyMatch string
	var rangeMatch string

	var descriptionList []string
	var keyList []string
	var minRangeList []string
	var maxRangeList []string

	keyLine := regexp.MustCompile(`^(?P<key>\w+.[0-9,]*[\)]?)\s\s+(?P<rem>.*)`)
	keyLineName := keyLine.SubexpIndex("key")
	remLineName := keyLine.SubexpIndex("rem")

	getRegLine := regexp.MustCompile(`^\s+(?P<regline>[\(=\w]* .*$)`)
	regLineName := getRegLine.SubexpIndex("regline")

	getRange := regexp.MustCompile(`^\s+Range:(?P<range>.*)`)
	rangeName := getRange.SubexpIndex("range")

	getMinMax := regexp.MustCompile(`(?P<min>^.*?)\s[\w]+\s(?P<max>.*$)`)
	min := getMinMax.SubexpIndex("min")
	max := getMinMax.SubexpIndex("max")

	for i := 0; i < len(lines); i++ {
		if keyLine.MatchString(lines[i]) {
			descriptionLine = strings.ReplaceAll(strings.Join(description, " "), `"`, "'")
			fmtItem := (fmtKeyMatch + descriptionLine + rangeMatch)
			if fmtItem != "" {
				descriptionList = append(descriptionList, strings.TrimSpace(descriptionLine))
				keyList = append(keyList, strings.TrimSpace(fmtKeyMatch))
			}

			match := keyLine.FindStringSubmatch(lines[i])
			fmtKeyMatch = strings.TrimSpace(strings.ReplaceAll(strings.ReplaceAll(strings.ReplaceAll(match[keyLineName], ",", "_"), "(", "_"), ")", ""))
			fmtRemLine := match[remLineName]

			description = []string{}
			description = append(description, fmtRemLine)

		} else if getRange.MatchString(lines[i]) {
			match := getRange.FindStringSubmatch(lines[i])
			rangeMatch = match[rangeName]
			if rangeMatch != "" {
				matchRanges := getMinMax.FindStringSubmatch(rangeMatch)
				fmt.Println(fmtKeyMatch)
				fmt.Println("min: ", matchRanges[min])
				fmt.Println("max:", matchRanges[max])
				minRangeList = append(minRangeList, strings.TrimSpace(matchRanges[min]))
				maxRangeList = append(maxRangeList, strings.TrimSpace(matchRanges[max]))
			} else {
				minRangeList = append(minRangeList, "")
				maxRangeList = append(maxRangeList, "")
			}

		} else if getRegLine.MatchString(lines[i]) {
			match := getRegLine.FindStringSubmatch(lines[i])
			fmtRegLine := strings.TrimSpace(match[regLineName])

			description = append(description, fmtRegLine)
		} else {
			continue
		}
	}
	return descriptionList, keyList, minRangeList, maxRangeList
}

func yamlInit(file *os.File) {
	streng := `  DaycentInputs:
    type: object
    properties:
      simualtion:
        type: object
        properties:
          data100:
            type: object
            properties:`
	file.Write([]byte(streng))
}

func writeToYaml(fileList []string, files fileList) {

	fileName := "swagger.yaml"
	file, err := os.OpenFile(
		fileName,
		os.O_WRONLY|os.O_TRUNC|os.O_CREATE,
		0666,
	)
	if err != nil {
		fmt.Println(err)
	}

	yamlInit(file)

	for i := 0; i < len(fileList); i++ {
		switch fileList[i] {
		case files.Crop:
			fmtFileName := strings.ReplaceAll(files.Crop, ".def", "")
			header := `
                ` + fmtFileName + `:
                  type: array
                  items:
                    type: object
                    properties:`
			file.Write([]byte(header))
			descriptionList, keyList, minRangeList, maxRangeList := handle(openFile(fileList[i]))
			for i := 0; i < len(keyList); i++ {
				elem := `
                        ` + keyList[i] + `:
                          description: "` + descriptionList[i] + `"
                          minimum: "` + minRangeList[i] + `"
                          maximum: "` + maxRangeList[i] + `"
                          type: number`
				file.Write([]byte(elem))
			}
		case files.Cult:
			fmtFileName := strings.ReplaceAll(files.Cult, ".def", "")
			header := `
                ` + fmtFileName + `:
                  type: array
                  items:
                    type: object
                    properties:`
			file.Write([]byte(header))
			descriptionList, keyList, minRangeList, maxRangeList := handle(openFile(fileList[i]))
			for i := 0; i < len(keyList); i++ {
				elem := `
                        ` + keyList[i] + `:
                          description: "` + descriptionList[i] + `"
                          minimum: "` + minRangeList[i] + `"
                          maximum: "` + maxRangeList[i] + `"
                          type: number`
				file.Write([]byte(elem))
			}
		case files.Fert:
			fmtFileName := strings.ReplaceAll(files.Fert, ".def", "")
			header := `
                ` + fmtFileName + `:
                  type: array
                  items:
                    type: object
                    properties:`
			file.Write([]byte(header))
			descriptionList, keyList, minRangeList, maxRangeList := handle(openFile(fileList[i]))
			for i := 0; i < len(keyList); i++ {
				elem := `
                        ` + keyList[i] + `:
                          description: "` + descriptionList[i] + `"
                          minimum: "` + minRangeList[i] + `"
                          maximum: "` + maxRangeList[i] + `"
                          type: number`
				file.Write([]byte(elem))
			}
		case files.Fire:
			fmtFileName := strings.ReplaceAll(files.Fire, ".def", "")
			header := `
                ` + fmtFileName + `:
                  type: array
                  items:
                    type: object
                    properties:`
			file.Write([]byte(header))
			descriptionList, keyList, minRangeList, maxRangeList := handle(openFile(fileList[i]))
			for i := 0; i < len(keyList); i++ {
				elem := `
                        ` + keyList[i] + `:
                          description: "` + descriptionList[i] + `"
                          minimum: "` + minRangeList[i] + `"
                          maximum: "` + maxRangeList[i] + `"
                          type: number`
				file.Write([]byte(elem))
			}
		case files.Fix:
			fmtFileName := strings.ReplaceAll(files.Fix, ".def", "")
			header := `
                ` + fmtFileName + `:
                  type: array
                  items:
                    type: object
                    properties:`
			file.Write([]byte(header))
			descriptionList, keyList, minRangeList, maxRangeList := handle(openFile(fileList[i]))
			for i := 0; i < len(keyList); i++ {
				elem := `
                        ` + keyList[i] + `:
                          description: "` + descriptionList[i] + `"
                          minimum: "` + minRangeList[i] + `"
                          maximum: "` + maxRangeList[i] + `"
                          type: number`
				file.Write([]byte(elem))
			}
		case files.Graz:
			fmtFileName := strings.ReplaceAll(files.Graz, ".def", "")
			header := `
                ` + fmtFileName + `:
                  type: array
                  items:
                    type: object
                    properties:`
			file.Write([]byte(header))
			descriptionList, keyList, minRangeList, maxRangeList := handle(openFile(fileList[i]))
			for i := 0; i < len(keyList); i++ {
				elem := `
                        ` + keyList[i] + `:
                          description: "` + descriptionList[i] + `"
                          minimum: "` + minRangeList[i] + `"
                          maximum: "` + maxRangeList[i] + `"
                          type: number`
				file.Write([]byte(elem))
			}
		case files.Harv:
			fmtFileName := strings.ReplaceAll(files.Harv, ".def", "")
			header := `
                ` + fmtFileName + `:
                  type: array
                  items:
                    type: object
                    properties:`
			file.Write([]byte(header))
			descriptionList, keyList, minRangeList, maxRangeList := handle(openFile(fileList[i]))
			for i := 0; i < len(keyList); i++ {
				elem := `
                        ` + keyList[i] + `:
                          description: "` + descriptionList[i] + `"
                          minimum: "` + minRangeList[i] + `"
                          maximum: "` + maxRangeList[i] + `"
                          type: number`
				file.Write([]byte(elem))
			}
		case files.Irri:
			fmtFileName := strings.ReplaceAll(files.Irri, ".def", "")
			header := `
                ` + fmtFileName + `:
                  type: array
                  items:
                    type: object
                    properties:`
			file.Write([]byte(header))
			descriptionList, keyList, minRangeList, maxRangeList := handle(openFile(fileList[i]))
			for i := 0; i < len(keyList); i++ {
				elem := `
                        ` + keyList[i] + `:
                          description: "` + descriptionList[i] + `"
                          minimum: "` + minRangeList[i] + `"
                          maximum: "` + maxRangeList[i] + `"
                          type: number`
				file.Write([]byte(elem))
			}
		case files.Omad:
			fmtFileName := strings.ReplaceAll(files.Omad, ".def", "")
			header := `
                ` + fmtFileName + `:
                  type: array
                  items:
                    type: object
                    properties:`
			file.Write([]byte(header))
			descriptionList, keyList, minRangeList, maxRangeList := handle(openFile(fileList[i]))
			for i := 0; i < len(keyList); i++ {
				elem := `
                        ` + keyList[i] + `:
                          description: "` + descriptionList[i] + `"
                          minimum: "` + minRangeList[i] + `"
                          maximum: "` + maxRangeList[i] + `"
                          type: number`
				file.Write([]byte(elem))
			}
		case files.Site:
			fmtFileName := strings.ReplaceAll(files.Site, ".def", "")
			header := `
                ` + fmtFileName + `:
                  type: array
                  items:
                    type: object
                    properties:`
			file.Write([]byte(header))
			descriptionList, keyList, minRangeList, maxRangeList := handle(openFile(fileList[i]))
			for i := 0; i < len(keyList); i++ {
				elem := `
                        ` + keyList[i] + `:
                          description: "` + descriptionList[i] + `"
                          minimum: "` + minRangeList[i] + `"
                          maximum: "` + maxRangeList[i] + `"
                          type: number`
				file.Write([]byte(elem))
			}
		case files.Tree:
			fmtFileName := strings.ReplaceAll(files.Tree, ".def", "")
			header := `
                ` + fmtFileName + `:
                  type: array
                  items:
                    type: object
                    properties:`
			file.Write([]byte(header))
			descriptionList, keyList, minRangeList, maxRangeList := handle(openFile(fileList[i]))
			for i := 0; i < len(keyList); i++ {
				elem := `
                        ` + keyList[i] + `:
                          description: "` + descriptionList[i] + `"
                          minimum: "` + minRangeList[i] + `"
                          maximum: "` + maxRangeList[i] + `"
                          type: number`
				file.Write([]byte(elem))
			}
		case files.Trem:
			fmtFileName := strings.ReplaceAll(files.Trem, ".def", "")
			header := `
                ` + fmtFileName + `:
                  type: array
                  items:
                    type: object
                    properties:`
			file.Write([]byte(header))
			descriptionList, keyList, minRangeList, maxRangeList := handle(openFile(fileList[i]))
			for i := 0; i < len(keyList); i++ {
				elem := `
                        ` + keyList[i] + `:
                          description: "` + descriptionList[i] + `"
                          minimum: "` + minRangeList[i] + `"
                          maximum: "` + maxRangeList[i] + `"
                          type: number`
				file.Write([]byte(elem))
			}
		default:
			fmt.Println("could not find file " + fileList[i])
		}
	}
}

func main() {
	files := fileList{
		Crop: "crop.def",
		Cult: "cult.def",
		Fert: "fert.def",
		Fire: "fire.def",
		Fix:  "fix.def",
		Graz: "graz.def",
		Harv: "harv.def",
		Irri: "irri.def",
		Omad: "omad.def",
		Site: "site.def",
		Tree: "tree.def",
		Trem: "trem.def",
	}

	fileList := []string{"crop.def", "cult.def", "fert.def", "fire.def", "fix.def", "graz.def", "harv.def", "irri.def", "omad.def", "site.def", "tree.def", "trem.def"}

	writeToYaml(fileList, files)

}
