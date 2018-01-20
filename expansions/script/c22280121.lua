--沉寂之晶石
--------The way of builtin name Is Adapted From c14141006.lua By 卡 莲  From YGOPro 222DIY--------
local m=22280121
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c22280020") end,function() require("script/c22280020") end)
cm.named_with_Spar=true
function cm.initial_effect(c)
	cm.AddXyzProcedureCustom(c,cm.mfilter,cm.xyzcheck,2,63)
	--maintain
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCountLimit(1)
	e0:SetCondition(cm.mtcon)
	e0:SetOperation(cm.mtop)
	c:RegisterEffect(e0)
	--Attribute
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_ADD_ATTRIBUTE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(cm.val)
	c:RegisterEffect(e1)
	--act limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(0,0xff)
	e2:SetValue(cm.aclimit)
	c:RegisterEffect(e2)
	--SpecialSummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(cm.cost)
	e3:SetTarget(cm.target)
	e3:SetOperation(cm.operation)
	c:RegisterEffect(e3)
end
function cm.mtcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function cm.mtop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) then
		e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	else
		if e:GetHandler():IsReleasable() then
			Duel.Release(e:GetHandler(),REASON_COST)
		end
	end
end
function cm.valfilter(c)
	return bit.band(c:GetOriginalType(),TYPE_MONSTER)~=0
end
function cm.val(e)
	local g=e:GetHandler():GetOverlayGroup():Filter(cm.valfilter,nil)
	local sum=0
	if g:FilterCount(Card.IsAttribute,nil,ATTRIBUTE_EARTH)>0 then sum=sum+0x01 end
	if g:FilterCount(Card.IsAttribute,nil,ATTRIBUTE_WATER)>0 then sum=sum+0x02 end
	if g:FilterCount(Card.IsAttribute,nil,ATTRIBUTE_FIRE)>0 then sum=sum+0x04 end
	if g:FilterCount(Card.IsAttribute,nil,ATTRIBUTE_WIND)>0 then sum=sum+0x08 end
	if g:FilterCount(Card.IsAttribute,nil,ATTRIBUTE_LIGHT)>0 then sum=sum+0x10 end
	if g:FilterCount(Card.IsAttribute,nil,ATTRIBUTE_DARK)>0 then sum=sum+0x20 end
	if g:FilterCount(Card.IsAttribute,nil,ATTRIBUTE_DEVINE)>0 then sum=sum+0x40 end
	return sum
end
function cm.aclimit(e,re,tp)
	return bit.band(e:GetHandler():GetAttribute(),re:GetHandler():GetOriginalAttribute())~=0 and not re:GetHandler():IsImmuneToEffect(e)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReleasable() end
	Duel.Release(c,REASON_COST)
end
function cm.rspfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsType(TYPE_RITUAL) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingMatchingCard(cm.rspfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.rspfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
--------The Following Part Is Adapted From c14141006.lua By 卡 莲  From YGOPro 222DIY,really thx again--------
function cm.mfilter(c)
	return c:IsType(TYPE_RITUAL) and c:IsRace(RACE_ROCK)
end
function cm.xyzcheck(g)
	return g:GetClassCount(Card.GetOriginalAttribute)==g:GetCount()
end
function cm.AddXyzProcedureCustom(c,func,gf,minc,maxc,xm,...)
	local ext_params={...}
	c:EnableReviveLimit()
	local maxc=maxc or minc
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(cm.XyzProcedureCustomCondition(func,gf,minc,maxc,ext_params))
	e1:SetOperation(cm.XyzProcedureCustomOperation(func,gf,minc,maxc,xm,ext_params))
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
	return e1
end
function cm.XyzProcedureCustomCondition(func,gf,minct,maxct,ext_params)
	return function(e,c,og,min,max)
		if c==nil then return true end
		if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
		local tp=c:GetControler()
		if Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_XMATERIAL) then return false end
		local minc=minct or 2
		local maxc=maxct or minct or 63
		if min then
			minc=math.max(minc,min)
			maxc=math.min(maxc,max)
		end
		local mg=nil
		if og then
			mg=og:Filter(cm.XyzProcedureCustomFilter,nil,c,func,ext_params)
		else
			mg=Duel.GetMatchingGroup(cm.XyzProcedureCustomFilter,tp,LOCATION_MZONE,0,nil,c,func,ext_params)
		end
		return maxc>=minc and cm.CheckGroup(mg,cm.CheckFieldFilter,nil,minc,maxc,tp,c,gf,c)
	end
end
function cm.XyzProcedureCustomOperation(func,gf,minct,maxct,xm,ext_params)
	return function(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
		local g=nil
		if og and not min then
			g=og
		else
			local mg=nil
			if og then
				mg=og:Filter(cm.XyzProcedureCustomFilter,nil,c,func,ext_params)
			else
				mg=Duel.GetMatchingGroup(cm.XyzProcedureCustomFilter,tp,LOCATION_MZONE,0,nil,c,func,ext_params)
			end
			local minc=minct or 2
			local maxc=maxct or minct or 63
			if min then
				minc=math.max(minc,min)
				maxc=math.min(maxc,max)
			end
			g=cm.SelectGroup(tp,HINTMSG_XMATERIAL,mg,cm.CheckFieldFilter,nil,minc,maxc,tp,c,gf,c)
		end
		c:SetMaterial(g)
		cm.OverlayGroup(c,g,xm,true)
	end
end
function cm.XyzProcedureCustomFilter(c,xyzcard,func,ext_params)
	if c:IsLocation(LOCATION_ONFIELD+LOCATION_REMOVED) and c:IsFacedown() then return false end
	return c:IsCanBeXyzMaterial(xyzcard) and c:IsType(TYPE_RITUAL) and (not func or func(c,xyzcard,table.unpack(ext_params)))
end
function cm.CheckFieldFilter(g,tp,c,f,...)
	if f and not f(g,...) then return false end
	if Duel.GetLocationCountFromEx then return Duel.GetLocationCountFromEx(tp,tp,g,c)>0 end
	return Duel.GetLocationCount(tp,LOCATION_MZONE)+g:FilterCount(aux.FConditionCheckF,nil,tp)>0
end
function cm.CheckGroupRecursive(c,sg,g,f,min,max,ext_params)
	sg:AddCard(c)
	local ct=sg:GetCount()
	local res=(ct>=min and f(sg,table.unpack(ext_params)))
		or (ct<max and g:IsExists(cm.CheckGroupRecursive,1,sg,sg,g,f,min,max,ext_params))
	sg:RemoveCard(c)
	return res
end
function cm.CheckGroup(g,f,cg,min,max,...)
	local min=min or 1
	local max=max or g:GetCount()
	if min>max then return false end
	local ext_params={...}
	local sg=Group.CreateGroup()
	if cg then sg:Merge(cg) end
	local ct=sg:GetCount()
	if ct>=min and ct<max and f(sg,...) then return true end
	return g:IsExists(cm.CheckGroupRecursive,1,sg,sg,g,f,min,max,ext_params)
end
function cm.SelectGroup(tp,desc,g,f,cg,min,max,...)
	local min=min or 1
	local max=max or g:GetCount()
	local ext_params={...}
	local sg=Group.CreateGroup()
	if cg then
		sg:Merge(cg)
	end
	local ct=sg:GetCount()
	local ag=g:Filter(cm.CheckGroupRecursive,sg,sg,g,f,min,max,ext_params)   
	while ct<max and ag:GetCount()>0 do
		local minc=1
		local finish=(ct>=min and f(sg,...))
		if finish then minc=0 end
		Duel.Hint(HINT_SELECTMSG,tp,desc)
		local tg=ag:Select(tp,minc,1,nil)
		if tg:GetCount()==0 then break end
		sg:Merge(tg)
		ct=sg:GetCount()
		ag=g:Filter(cm.CheckGroupRecursive,sg,sg,g,f,min,max,ext_params)
	end
	return sg
end
function cm.OverlayFilter(c,nchk)
	return nchk or not c:IsType(TYPE_TOKEN)
end
function cm.OverlayGroup(c,g,xm,nchk)
	if not nchk and (not c:IsLocation(LOCATION_MZONE) or c:IsFacedown() or g:GetCount()<=0 or not c:IsType(TYPE_XYZ)) then return end
	local tg=g:Filter(cm.OverlayFilter,nil,nchk)
	if tg:GetCount()==0 then return end
	local og=Group.CreateGroup()
	for tc in aux.Next(tg) do
		if tc:IsStatus(STATUS_LEAVE_CONFIRMED) then
			tc:CancelToGrave()
		end
		og:Merge(tc:GetOverlayGroup())
	end
	if og:GetCount()>0 then
		if xm then
			Duel.Overlay(c,og)
		else
			Duel.SendtoGrave(og,REASON_RULE)
		end
	end
	Duel.Overlay(c,tg)
end