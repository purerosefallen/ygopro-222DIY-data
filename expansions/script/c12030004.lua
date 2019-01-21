--小黄
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m=12030004
local cm=_G["c"..m]
cm.rssetcode="yatori"
function c12030004.initial_effect(c)
	 --Recover
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12030004,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_DAMAGE)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c12030004.condition)
	e1:SetTarget(c12030004.target)
	e1:SetOperation(c12030004.operation)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12030004,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(c12030004.distg)
	e2:SetOperation(c12030004.disop)
	c:RegisterEffect(e2)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(12030004,2))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(c12030004.drcon)
	e3:SetTarget(c12030004.drtg)
	e3:SetOperation(c12030004.drop)
	c:RegisterEffect(e3)
end
c12030004.halo_yatori=1
function c12030004.named_with_yatori(c)
	local m=_G["c"..c:GetCode()]
	return m and m.halo_yatori
end
function c12030004.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function c12030004.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ev*2)
end
function c12030004.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		Duel.Recover(tp,ev*2,REASON_EFFECT)
	end
end
function c12030004.filter1(c)
	return c:CheckSetCard("yatori") and c:IsAbleToHand()
end
function c12030004.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(c12030004.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_MZONE)
end
function c12030004.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectMatchingCard(tp,c12030004.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetHandler())
	if g:GetCount()>0 then
	   local atk=g:GetFirst():GetAttack()
	   Duel.SendtoHand(g,nil,REASON_EFFECT)
	   Duel.ConfirmCards(1-tp,g)
	   Duel.Recover(tp,atk,REASON_EFFECT)
	end
	local cc=Duel.SelectMatchingCard(tp,c12030004.filter1,tp,LOCATION_GRAVE,0,1,1,nil)
	if cc:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(12030004,3)) then
	   Duel.SendtoHand(cc,nil,REASON_EFFECT)
	   Duel.ConfirmCards(1-tp,cc)
	end
end
function c12030004.drcon(e,tp,eg,ep,ev,re,r,rp)
	e:SetLabel(e:GetHandler():GetPreviousControler())
	return e:GetHandler():IsReason(REASON_EFFECT)
end
function c12030004.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if  rp==1-tp and tp==e:GetLabel() then
		if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_MZONE,2,nil) end
		Duel.RegisterFlagEffect(tp,12030004+100,RESET_PHASE+PHASE_END,0,1)
		e:SetCategory(CATEGORY_TODECK)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,2,tp,LOCATION_ONFIELD)
	else
		if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0,LOCATION_MZONE,1,nil) end
		e:SetCategory(CATEGORY_TOGRAVE)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_ONFIELD)
	end
end
function c12030004.drop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,12030004+100)==0 then
	   local g=Duel.SelectMatchingCard(1-tp,Card.IsAbleToGrave,tp,0,LOCATION_MZONE,1,1,nil)
	   if g:GetCount()>0 then
		  Duel.SendtoGrave(g,REASON_RULE)
	   end
	else
	   local g=Duel.SelectMatchingCard(1-tp,Card.IsAbleToDeck,tp,0,LOCATION_MZONE,2,2,nil)
	   if g:GetCount()>0 then
		  Duel.SendtoDeck(g,nil,2,REASON_RULE)
	   end
	end
end