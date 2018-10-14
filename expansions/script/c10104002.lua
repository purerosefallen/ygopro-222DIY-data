--兹鲁夫咒符-暗影
local m=10104002
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1) 
	--material
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,m+100)
	e2:SetTarget(cm.mattg)
	e2:SetOperation(cm.matop)
	c:RegisterEffect(e2)   
end
function cm.matfilter(c,rc)
	return c:IsFaceup() and (rc:IsAbleToRemove() or c:IsType(TYPE_XYZ))
end
function cm.checkzone(tp)
	local zone=0
	local lg=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)
	for tc in aux.Next(lg) do
		zone=bit.bor(zone,tc:GetColumnZone(LOCATION_MZONE,tp))
	end
	return bit.bnot(zone),zone
end
function cm.mattg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local zone=cm.checkzone(tp)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.matfilter(chkc,c) end
	if chk==0 then return Duel.IsExistingTarget(cm.matfilter,tp,LOCATION_MZONE,0,1,nil,c) and Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_CONTROL,zone)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,cm.matfilter,tp,LOCATION_MZONE,0,1,1,nil,c)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_ONFIELD)
end
function cm.matop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) or not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
	local zone,zone2=cm.checkzone(tp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_CONTROL,zone)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,zone2)
	local nseq=math.log(s,2)
	Duel.MoveSequence(tc,nseq)
	if not tc:IsType(TYPE_XYZ) then
	   Duel.Remove(c,POS_FACEUP,REASON_EFFECT)
	else
	   if tc:IsImmuneToEffect(e) then return end
	   Duel.Overlay(tc,Group.FromCards(c))
	   local g=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,tp,tc)
	   if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
		  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		  local tg=g:Select(tp,1,1,nil)
		  Duel.HintSelection(tg)
		  Duel.SendtoHand(tg,nil,REASON_EFFECT)
	   end
	end
end
function cm.thfilter(c,tp,tc)
	local seq=c:GetSequence()
	if seq>4 then return end
	if c:IsControler(1-tp) then seq=4-seq end
	return math.abs(tc:GetSequence()-seq)==1 and c:IsAbleToHand()
end
function cm.matfilter2(c,tp,tc)
	local seq=c:GetSequence()
	if seq>4 then return end
	if c:IsControler(1-tp) then seq=4-seq end
	return math.abs(tc:GetSequence()-seq)==1 and (c:IsControler(tp) or c:IsAbleToChangeControler())
end
function cm.filter(c)
	return c:IsSetCard(0xa330) and c:IsAbleToGrave() and not c:IsCode(m)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
