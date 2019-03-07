--生死轮舞 扭曲的湮灭葬歌
if not pcall(function() require("expansions/script/c88946402") end) then require("script/c88946402") end
local m=88946412
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=rsef.ACT(c)
	local e2=rsef.QO_NEGATE_ACT(c,{1,m},"des",LOCATION_SZONE,rscon.negcon(cm.filter,true),rscost.cost({cm.cfilter,"rm",LOCATION_ONFIELD+LOCATION_EXTRA }))
	local op=e2:GetOperation()
	e2:SetOperation(cm.negop(op))
	local e3=rsef.FTO(c,EVENT_LEAVE_FIELD,{m,0},{1,m},"te","de",LOCATION_SZONE,cm.con,nil,rstg.target(rsop.list(cm.putfilter,"te",LOCATION_DECK+LOCATION_GRAVE)),cm.op)
end
function cm.con(e,tp,eg)
	local f=function(c,p)
		return c:IsPreviousLocation(LOCATION_ONFIELD) and c:GetPreviousControler()==p and c:IsOriginalSetCard(0x8964) and c:IsReason(REASON_EFFECT)
	end
	return eg:IsExists(f,1,nil,tp)
end
function cm.op(e,tp)
	if not aux.ExceptThisCard(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.putfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil):GetFirst()
	if not tc then return end
	local b1=Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)
	local b2=true
	local op=rsof.SelectOption(tp,b1,{m,0},b2,{m,1})
	if op==1 then
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	else
		Duel.SendtoExtraP(tc,nil,REASON_EFFECT)
	end 
end
function cm.putfilter(c,e,tp)
	return c:IsSetCard(0x8964) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function cm.negop(op)
	return function(e,...)
		if not aux.ExceptThisCard(e) then return end
		op(e,...)
	end
end
function cm.filter(e,tp,re,rp,tg,loc)
	return loc&LOCATION_HAND+LOCATION_GRAVE ~=0
end
function cm.cfilter(c)
	return c:IsSetCard(0x8964) and c:IsType(TYPE_PENDULUM) and c:IsAbleToRemoveAsCost()
end
