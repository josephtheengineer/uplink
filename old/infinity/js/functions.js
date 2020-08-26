// Title          : functions.js
// Project        : InfinityAI
// Usage          : Everything that the main brain generator calls A LOT, use little if no logging.
// Author         : Joseph The Engineer
// Date Created   : --
// Date Updated   : 26-02-2018

var exec = require('child_process').exec;
var chalk = require('chalk')
var fs = require('fs')
var logger = require('winston')
var Chart = require('chart.js')

var creationTime
var parentA
var parentB

var loaded = false;

logger.add(
  logger.transports.File, {
    filename: 'logs/' + new Date().getTime() + '.log',
    level: 'info',
    json: true,
    timestamp: true
  }
)

// Log Manager ------------------------------------

function print(msg){
  logManager(msg, 0)
}

function start(msg){
  for (var i = msg.length; i < 40; i++){
    msg = msg + ' '
  }
    logManager(msg, 1)
}

function finish(){
    logManager('                         Done!', 2)
}

function error(msg){
  logManager(msg, 3)
}

var started = false
var pending = []

function logManager(msg, type){
  if (type == 0){
    if (started){
      pending.push(msg)
    } else {
      logger.info(msg)
    }
  } else if (type == 1){
    //document.getElementById('status').innerHTML = 'active'
    process.stdout.write(chalk.blue(msg))
    started = true
  } else if (type == 2 && started) {
    //document.getElementById('status').innerHTML = 'idle'
    process.stdout.write(chalk.green(msg + '\n'))
    console.log('')
    started = false
    for (var i = 0; i < pending.length; i++) {
      if (pending[i] != '') {
        logger.info(pending[i])
        pending[i] = ''
      }
    }
  } else if (type == 3){
    process.stdout.write(chalk.red('                       Failed!' + '\n'))
    console.log('')
    started = false
    for (var i = 0; i < pending.length; i++) {
      if (pending[i] != '') {
        logger.info(pending[i])
        pending[i] = ''
      }
    }
    process.stdout.write(chalk.red('error: ' + msg + '\n'))
    console.log('')
    started = true
  }
}

// Neuron Fetchers ------------------------------------

function reset(){
  start('Reseting InfinityAI...')
  exec('rm -r networks/*', function(error, stdout, stderr) { });
  numberArray = []
  fitnessArray = []

  for (var i = 0; i < 2; i++){
    generateNeurons()
    traceConnections()
    saveNetwork()
  }
  finish()
}

function neuronInfo (neuron, array) {
  try {
    if (array == null) {
      return neuronArray[neuron].split(' ')
    } else if (array == 'A') {
      return parentArrayA[neuron].split(' ')
    } else if (array == 'B') {
      return parentArrayB[neuron].split(' ')
    }
  } catch (e) {
      logger.info('error on split of neuron ' + neuron + ' on array ' + array)
      //logger.info(neuronArray)
      logger.info(e)
      return 'error'
  }
}

function validateNeuron (neuron) {
  if(neuronArray[neuron] == null){
    return false
  } else {
    return true
  }
}

function isActive(neuron){
  if (neuronInfo(neuron)[4] === '1') {
    return true
  } else {
    return false
  }
}

function fetchIndex(x, y) {
  return Number(y) * neuronWidth + Number(x)
}

function manualOverride(){
  process.stdout.write(chalk.red('=== INFINITY AI - MANUAL ANALOG OVERRIDE ENGAGED  ===' + '\n'))
  console.log('')
  print('manual override called')
  print('Autonomous mode disabled')
  stop()
}

function eStop(){
  process.stdout.write(chalk.red('=== INFINITY AI - EMERGENCY SHUTDOWN INITIATED ===' + '\n'))
  console.log('')
  print('e-stop called')
  print('Shutdown procedure commencing...')
  process.exit()
}

function setActive(x, y){
    var n = fetchIndex(x, y)
  if (neuronArray[n] != null) {
    //print(neuronInfo(n))
    neuronArray[n] = (neuronInfo(n)[0] + ' ' + neuronInfo(n)[1] + ' ' + neuronInfo(n)[2] + ' ' + neuronInfo(n)[3] + ' 1 ' + neuronInfo(n)[5])
  }
}

function setIdle(x, y){
    var n = fetchIndex(x, y)
  if (neuronArray[n] != null) {
    //print(neuronInfo(n))
    neuronArray[n] = (neuronInfo(n)[0] + ' ' + neuronInfo(n)[1] + ' ' + neuronInfo(n)[2] + ' ' + neuronInfo(n)[3] + ' 0 ' + neuronInfo(n)[5])
  }
}

function bindNeuron(x, y, type){
    var n = fetchIndex(x, y)
  if (neuronArray[n] != null) {
    //print(neuronInfo(n))
    neuronArray[n] = (neuronInfo(n)[0] + ' ' + neuronInfo(n)[1] + ' ' + neuronInfo(n)[2] + ' ' + type + ' ' + neuronInfo(n)[4] + ' ' + neuronInfo(n)[5])
  }
}

var i = 0, on = true, catchError = false

function rmain(){
  i = 0
  repeat = document.getElementById("repeat").value;
  wait = document.getElementById("wait").value;
  main()
}

function main() {
  process.stdout.write(chalk.red('=== INFINITY AI - BOOT UP SEQUENCE INITIATED ===' + '\n'))
  console.log('')
  print('Infinity AI Type: ANN-EA Class: Goal-Linking')
  print('Iteration number ' + i)

  if (catchError == false){

    dev()
    run()

    i++;
    if( i < repeat && on == true){
        setTimeout( main, wait )
    }
  } else {
    try {

      dev()
      run()

      i++;
      if( i < repeat && on == true){
          setTimeout( main, wait )
      }
    } catch (e){
      //print(neuronArray)
      error(e + '\n' + new Error().stack)
    }
  }
}

function stop(){
  on = !on;
}

// Generation Savers ------------------------------------

function saveNetwork () {
  start('Saving network...')

  //fitness = document.getElementById("fitnessOverride").value;
  //fitnessArray.push(fitness)

  fs.writeFileSync('networks/' + creationTime + '.network', neuronArray)
  if (fs.existsSync('networks/index.txt')) {
      var index = fs.readFileSync('networks/' + 'index.txt', 'utf8')
      fs.writeFileSync('networks/' + 'index.txt', index + ',' + creationTime + '|' + fitness)

      try {
        var qIndex = fs.readFileSync('networks/' + 'qIndex.txt', 'utf8')
        fs.writeFileSync('networks/' + 'qIndex.txt', qIndex + ',' + question + '|' + goal)
      } catch (e){
          print('error saving qIndex')
      }
  } else {
    var index = ''
    fs.writeFileSync('networks/' + 'index.txt', index + creationTime + '|' + fitness)

    try {
      var qIndex = fs.readFileSync('networks/' + 'qIndex.txt', 'utf8')
      fs.writeFileSync('networks/' + 'qIndex.txt', qIndex + ',' + question + '|' + goal)
    } catch (e){
        print('error saving qIndex')
    }
  }
  finish()
}

function loadNetwork (option) {
  var heighestFitness = 0

  //start('Loading network into slot ' + option + '...')
  var index = fs.readFileSync('networks/' + 'index.txt', 'utf8')
  print(index)
  var fileNames = index.split(',')

 //  print('Fetched latest networks: ' + fileNames)

  var potentialParent = []

  for (var i = 0; i < fileNames.length; i++) {
      if (fileNames[i].split('|')[1] >= heighestFitness) {
        heighestFitness = fileNames[i].split('|')[1]
      }
  }

  print('heighestFitness = ' + heighestFitness)

  //Chose heighest one
  for (var i = 0; i < fileNames.length; i++) {
    if (option == 1){
      if (fileNames[i].split('|')[1] >= (heighestFitness)) { // ADD -1
        potentialParent.push(fileNames[i].split('|')[0])
      }
    } else if (option == 2) {
      if (fileNames[i].split('|')[1] >= (heighestFitness) && fileNames[i].split('|')[0] != parentA) { // ADD -1
        potentialParent.push(fileNames[i].split('|')[0])
      }
    }
  }

  if (potentialParent.length <= 0){
    potentialParent.push(parentA)
  }

 //  print('Potential parents: ' + potentialParent)
  var chosenParent = Math.floor(Math.random() * potentialParent.length)
 //  print('Number is ' + chosenParent)
  print('Chosen network is ' + potentialParent[chosenParent])

  var search = index.search(potentialParent[chosenParent])
  print(search)
  var pie = index.substring(search, index.length - 1);
  print(pie)
  var pie2 = pie.substring(potentialParent[chosenParent].length + 1, pie.length - 1);
  print(pie2)

  var search2 = pie2.search(',')
  print('search2 | ' + search2)
  var res = pie2.substr(0, search2);
  print(res)

  if (option == 1){
    parentA = potentialParent[chosenParent]
    fitnessA = res
    print('A!!!!' + res)
  } else if (option == 2){
    parentB = potentialParent[chosenParent]
    fitnessB = res
    print('B!!!!' + res)
  }

  if (option == 0){
   neuronArray = fs.readFileSync('networks/' + potentialParent[chosenParent] + '.network', 'utf8').split(',')
 } else if (option == 1) {
    parentArrayA = fs.readFileSync('networks/' + potentialParent[chosenParent] + '.network', 'utf8').split(',')
  } else if (option == 2) {
    parentArrayB = fs.readFileSync('networks/' + potentialParent[chosenParent] + '.network', 'utf8').split(',')
  }
  finish()
}

// Render Stuff ------------------------------------

function refreshScreen () {
  start('Refreshing screen...')

  if (loaded == false){
    document.getElementById('top-loading').innerHTML =
    `        <div class="progress">
              <div class="determinate" style="width: 0%"></div>
            </div>`

    document.getElementById('main-loading').innerHTML =
    `      <div class="center-align" id="center-loading">
              <h1 style="font-family: 'Quicksand', sans-serif; color: white;">Infinity AI</h1>

              <div class="preloader-wrapper big active">
                <div class="spinner-layer spinner-teal-only">
                  <div class="circle-clipper left">
                    <div class="circle"></div>
                  </div><div class="gap-patch">
                    <div class="circle"></div>
                  </div><div class="circle-clipper right">
                    <div class="circle"></div>
                  </div>
                </div>
              </div>
          </div>`

    document.getElementById('content').innerHTML =
    `
    <div class="card-panel teal">
                  <div class="input-field col s2" style="height:25; margin-top:20;"> <input style="font-size: 20px; height: 25;" placeholder="Ask me anything..." id="question" type="text" class="validate"> </div>
    </div>

    <div class="row">
      <div class="col s12 m20">
        <div class="card-panel teal darken-3" style="background-color:#25252C !important;">
          <canvas id="myChart"></canvas>
        </div>
      </div>
    </div>

    <div class="row">

              <div class="col s12 m4">
                <div class="card-panel teal darken-3" style="padding-right:0; padding-left:0; padding-top:0; padding-bottom:1;">
                  <div class="card-image">
                    <div class="card-panel white" style="padding-right:0; padding-left:0; padding-top:0; padding-bottom:0;">
                      <span class="card-title"><p align=center>Child Array<p></span>
                    </div>
                  </div>
                  <p id='child' style="color:white;" align="center"></p>
                  <div id="neuronTable0" style="margin-right:24; margin-left:24; margin-top:24;"></div>
                </div>
              </div>

              <div class="col s12 m4">
                <div class="card-panel teal darken-3" style="padding-right:0; padding-left:0; padding-top:0; padding-bottom:1;">
                  <div class="card-image">
                    <div class="card-panel white" style="padding-right:0; padding-left:0; padding-top:0; padding-bottom:0;">
                      <span class="card-title"><p align=center>Parent Array A<p></span>
                    </div>
                  </div>
                  <p id='parentA' style="color:white;" align="center"></p>
                  <div id="neuronTable1" style="margin-right:24; margin-left:24; margin-top:24;"></div>
                </div>
              </div>

              <div class="col s12 m4">
                <div class="card-panel teal darken-3" style="padding-right:0; padding-left:0; padding-top:0; padding-bottom:1;">
                  <div class="card-image">
                    <div class="card-panel white" style="padding-right:0; padding-left:0; padding-top:0; padding-bottom:0;">
                      <span class="card-title"><p align=center>Parent Array B<p></span>
                    </div>
                  </div>
                  <p id='parentB' style="color:white;" align="center"></p>
                  <div id="neuronTable2" style="margin-right:24; margin-left:24; margin-top:24"></div>
                </div>
              </div>
              </div>`
    loaded = true
  }

  /*
  document.getElementById('fitness').innerHTML = "Fitness: " + fitness
  document.getElementById('fitness2').innerHTML = fitness
  document.getElementById('fitnessA').innerHTML = fitnessA
  document.getElementById('fitnessB').innerHTML = fitnessB

  document.getElementById('title').innerHTML = 'Infinity AI'
  document.getElementById('childName').innerHTML = creationTime

  document.getElementById('species').innerHTML = fs.readFileSync('networks/' + 'index.txt', 'utf8')
  */

  document.getElementById('parentA').innerHTML = parentA + ' | ' + fitnessA
  document.getElementById('parentB').innerHTML = parentB + ' | ' + fitnessB
  document.getElementById('child').innerHTML = creationTime + ' | ' + fitness

  print(fitnessA)
  print(fitnessB)

  //document.getElementById('inputArray').innerHTML = inputArray
  //document.getElementById('outputArray').innerHTML = outputArray

  //document.getElementById('totalNeurons').innerHTML = neuronArray.length + ' (' + neuronWidth + ' x ' + neuronHeight + ') neurons.'

  table(null, 'neuronTable0')
  table('A', 'neuronTable1')
  table('B', 'neuronTable2')
  //tableScreen('neuronTableC')
  //tableRaw()
  graph()
  finish()
}

function graph(){
  var numberArray = []
  for (var i = 0; i < fitnessArray.length; i++) {
    numberArray.push(i)
  }
  var ctx = document.getElementById('myChart');
  var myChart = new Chart(ctx, {
      type: 'line',
      responsive: true,
      maintainAspectRatio: false,
      data: {
          labels: numberArray,
          datasets: [{
              label: 'Fitness',
              data: fitnessArray,
              backgroundColor: [
                  'rgba(255, 99, 132, 0.2)',
                  'rgba(54, 162, 235, 0.2)',
                  'rgba(255, 206, 86, 0.2)',
                  'rgba(75, 192, 192, 0.2)',
                  'rgba(153, 102, 255, 0.2)',
                  'rgba(255, 159, 64, 0.2)'
              ],
              borderColor: [
                  'rgba(255,99,132,1)',
                  'rgba(54, 162, 235, 1)',
                  'rgba(255, 206, 86, 1)',
                  'rgba(75, 192, 192, 1)',
                  'rgba(153, 102, 255, 1)',
                  'rgba(255, 159, 64, 1)'
              ],
              borderWidth: 1
          }]
      },
      options: {
        animation: false,
        scales: {
          xAxes: [{
                      gridLines: {
                          color: "rgba(0, 0, 0, 0)",
                      },
                      ticks: {
                          stepSize: 5
                      }
                  }],
          yAxes: [{
                      gridLines: {
                          color: "rgba(0, 0, 0, 0)",
                      },
                      ticks: {
                          stepSize: 1
                      }
                  }]
          }
      }
  });
}

function table(network, id){
  var html

  var circleRed = '<td><div class="circleRed"></div></td>'
  var circleGreen = '<td><div class="circleGreen"></div></td>'
  var circleBlue = '<td><div class="circleBlue"></div></td>'
  var circleGrey = '<td><div class="circleGrey"></div></td>'

  var triangleRed = '<td><div class="triangleRed"></div></td>'
  var triangleGreen = '<td><div class="triangleGreen"></div></td>'
  var triangleBlue = '<td><div class="triangleBlue"></div></td>'
  var triangleGrey = '<td><div class="triangleGrey"></div></td>'

  var squareRed = '<td><div class="squareRed"></div></td>'
  var squareGreen = '<td><div class="squareGreen"></div></td>'

  var selectedNeuron = 0

  html = ' '
  html = html + '<table>'
  for (var a = 0; a < neuronHeight; a++){
    html = html + '<tr>'
    for (var b = 0; b < neuronWidth; b++) {
 /*     if (selectedNeuron == goal) {
        if (neuronInfo(selectedNeuron, network)[4] === '1') {
          html = html + circleBlue // ON
          selectedNeuron++
        } else {
          html = html + circleGrey // OFF
          selectedNeuron++
        }
      } else*/ if (neuronInfo(selectedNeuron, network)[3] == 'pixel') {
        if (neuronInfo(selectedNeuron, network)[4] === '1') {
          html = html + squareGreen // ON
          selectedNeuron++
        } else {
          html = html + squareRed // OFF
          selectedNeuron++
        }
      } else if (neuronInfo(selectedNeuron, network)[3] != 0) {
        if (neuronInfo(selectedNeuron, network)[4] === '1') {
          html = html + triangleGreen // ON
          selectedNeuron++
        } else {
          html = html + triangleRed // OFF
          selectedNeuron++
        }
      } else {
        if (neuronInfo(selectedNeuron, network)[4] === '1') {
          html = html + circleGreen // ON
          selectedNeuron++
        } else {
          html = html + circleRed // OFF
          selectedNeuron++
        }
      }
    }
    html = html + '</tr>'
  }
  html = html + '</table>'

  document.getElementById(id).innerHTML=html
}

function tableRaw(){
  var html

  var selectedNeuron = 0

  html = ' '
  html = html + '<table>'
  for (var a = 0; a < neuronHeight; a++){
    html = html + '<tr>'
    for (var b = 0; b < neuronWidth; b++) {
      html = html + '<td>' + neuronArray[selectedNeuron] + '</td>'
    }
    html = html + '</tr>'
  }
  html = html + '</table>'

  document.getElementById('rawNeuronTable').innerHTML=html
}
