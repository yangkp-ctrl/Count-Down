PROPERTIES = {year=0, month=0, day=0, hour=0, min=0, sec=0}
totalTime = 0
startTime = 0
isWorkOvertime = false

YYYY = 2021
MM = 1
DD = 5
H = 8
M = 0
S = 0

function Initialize()

	stringDate = tolua.cast(SKIN:GetMeter("Date"), "CMeterString")
	stringHour = tolua.cast(SKIN:GetMeter("Hour"), "CMeterString")
	stringMinute = tolua.cast(SKIN:GetMeter("Minute"), "CMeterString")
	stringSecond = tolua.cast(SKIN:GetMeter("Second"), "CMeterString")
	stringmSecond = tolua.cast(SKIN:GetMeter("mSecond"), "CMeterString")

	startTime = os.time(getStartWorkTime())
	countdownTime = getOffWorkTime()
	totalTime = os.time(countdownTime)-startTime
	progress = 0
	
end -- function Initialize

function Update()
	
	local rLeft = os.time(countdownTime) - os.time()
	if rLeft < 0 then
		rLeft = 0
	end
	
	local dLeft = math.floor(rLeft/60/60/24)
	local hLeft = math.floor(rLeft/60/60)%24
	local mLeft = math.floor(rLeft/60)%60
	local sLeft = math.floor(rLeft)%60
	local msLeft = math.floor(1000-(os.clock()*1000)%1000)

	if rLeft == 0 then
		stringmSecond:SetText(0)
	else
		stringmSecond:SetText(msLeft)
	end
	
	if totalTime > 0 and progress <= 1 then
		progress = (os.time()-startTime)/totalTime
		local progressWidth = getMeterWidth() * progress
		progressMeter = SKIN:GetMeter("progress")
		progressMeter:SetW(progressWidth)
		
		local color = getCurrentColor(progress)
		--myMeter:SetSolidColor(color)
		--myMeter:SetOption('SolidColor', color)
	end
	
	stringDate:SetText(dLeft)
	stringHour:SetText(hLeft)
	stringMinute:SetText(mLeft)
	stringSecond:SetText(sLeft)

end -- function Update

function getMeterWidth()
	local meterWidth = SKIN:GetMeter("Note"):GetW() 
		+ SKIN:GetMeter("Date"):GetW()
		+ SKIN:GetMeter("Hour"):GetW()
		+ SKIN:GetMeter("Minute"):GetW()
		+ SKIN:GetMeter("Second"):GetW()
	return meterWidth
end

function getOffWorkTime()
	local w = os.date("%w")
	local hour = 21
	if w == "5" then
		hour = 18
	end
	if isWorkOvertime == false then
		hour = 18
	end
	
	return {year=YYYY, month=MM, day=DD, hour=H, min=M, sec=S}
end

function getStartWorkTime()
	return {year=2020, month=12, day=16, hour=15, min=33, sec=35}
end

function getCurrentColor(progress)
	local startR = 30
	local startG = 199
	local startB = 230
	
	local endR = 146
	local endG = 185
	local endB = 1
	
	local currentR = getCurrentValue(startR, endR, progress)
	local currentG = getCurrentValue(startG, endG, progress)
	local currentB = getCurrentValue(startB, endB, progress)
	
	local RGB = {}
    RGB.r = currentR
    RGB.g = currentG
    RGB.b = currentB
	return RGB
end

function getCurrentValue(startValue, endValue, progress)
	local left = endValue - startValue
	if left == 0 then
		return startValue
	end
	
	local currentValue = startValue + left * progress
	return currentValue
end