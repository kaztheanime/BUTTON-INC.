Config								= require 'config'
PaperStage						= require 'paper-stage'
DatGUI								= require './dat'
FluidablePath	= require 'fluidable-path'

###
auth: Kimura
data: 2016/05/20
###

class Main
	constructor: () ->
		@dpr = if window.devicePixelRatio == undefined then 1 else window.devicePixelRatio
		@$window = $(window)
		$("#Canvas").append('<canvas id="'+Config.Canvas.paper+'">')
		@$canvas = $("#" + Config.Canvas.paper)
		@canvas = @$canvas.get(0)
		@context = @canvas.getContext('2d')
		@isFirstScene = true

		# paper.js 設定
		@paper = new PaperStage(@$canvas,@dpr)

		# イベント設定
		@$window.on('resize', @onResize).trigger('resize')

		# Container
		@container = new paper.Group()
		@paper.stage.addChild @container

		# ベース
		@baseSVG = @container.importSVG Config.SVG.BASE
		@baseSVG.remove()

		# 骨格の線
		@bone = @baseSVG.children[1]
		@bone.strokeWidth = 0.25
		@bone.strokeColor = '#ff0000'
		@bone.fillColor = new paper.Color 0,0,0,0
		@container.addChild @bone

		@fluid = new FluidablePath @bone
		@fluid.strokeWidth = 0.25
		@fluid.strokeColor = '#0000ff'
		@fluid.fillColor = new paper.Color 0,0,0,0
		@container.addChild @fluid
		@fluid.selected = true
		@fluid.fullySelected = true


		@container.scale(4)
		@dat = new DatGUI([@fluid])


		# update
		paper.view.onFrame = @onUpdate

		return

	# 
	# メインupdate
	# 
	onUpdate: =>
		@fluid.update()
		paper.view.update(true)
		return

	# 
	# リサイズ処理
	# 
	onResize: =>
		# ステージサイズ設定
		@stageWidth = @$window.width()
		@stageHeight = @$window.height()
		
		# paperリサイズ
		@paper.resize(@stageWidth, @stageHeight)

		return

	
#
# DOM READY
#
$(()->
	window.main = new Main()
)
