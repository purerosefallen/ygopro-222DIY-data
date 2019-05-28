--潜水小狐
if not pcall(function() require("expansions/script/c33331100") end) then require("script/c33331100") end
local m=33331104
local cm=_G["c"..m]
function cm.initial_effect(c)
	rslf.SpecialSummonFunction(c,m,cm.con,cm.op,cm.buff)
end
function cm.cfilter(c)
	return rslf.filter0(c) and c:IsType(TYPE_NORMAL) and c:IsAbleToHandAsCost() and c:IsFaceup()
end
function cm.con(e,tp)
	return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_EXTRA,0,1,nil)
end
function cm.op(e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local tg=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	Duel.SendtoHand(tg,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tg)
end
function cm.buff(c)
	local e1=rsef.SV_CANNOT_BE_TARGET({c,true},"effect")
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	local e2=rsef.I({c,true},{m,0},nil,"td,tg",nil,LOCATION_MZONE,cm.tdcon,nil,cm.tdtg,cm.tdop)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EFFECT_CANNOT_DISABLE)
	c:RegisterEffect(e3,true)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCode(EFFECT_CANNOT_DISEFFECT)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(cm.efilter)
	c:RegisterEffect(e4,true)
	return e1,e2,e3,e4
end
function cm.efilter(e,ct)
	local te=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT)
	return te:GetHandler()==e:GetHandler()
end
function cm.tdcon(e,tp)
	return Duel.GetFieldGroupCount(tp,0,LOCATION_GRAVE)>Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)+1
end
function cm.tdfilter(c)
	return rslf.filter0(c) and c:IsFaceup() and c:IsAbleToGrave()
end
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_GRAVE)-Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)-1
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tdfilter,tp,LOCATION_EXTRA,0,1,nil) and ct>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,ct,1-tp,LOCATION_GRAVE)
end
function cm.tdop(e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.tdfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	if #g<=0 or Duel.SendtoGrave(g,REASON_EFFECT)<=0 or not g:GetFirst():IsLocation(LOCATION_GRAVE) then return end
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_GRAVE)-Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)
	if ct>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local tg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(Card.IsAbleToDeck),tp,0,LOCATION_GRAVE,ct,ct,nil)
		Duel.HintSelection(tg)
		Duel.SendtoDeck(tg,nil,2,REASON_EFFECT)
	end
end
