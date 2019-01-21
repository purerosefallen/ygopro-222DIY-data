--小黄
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m=12030002
local cm=_G["c"..m]
cm.rssetcode="yatori"
function c12030002.initial_effect(c)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12030002,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c12030002.condition)
	e1:SetTarget(c12030002.target)
	e1:SetOperation(c12030002.operation)
	c:RegisterEffect(e1)
	--Search or Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12030002,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetTarget(c12030002.distg)
	e2:SetOperation(c12030002.disop)
	c:RegisterEffect(e2)
	--to grave
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(12030002,2))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(c12030002.drcon)
	e3:SetTarget(c12030002.drtg)
	e3:SetOperation(c12030002.drop)
	c:RegisterEffect(e3)
end
c12030002.halo_yatori=1
function c12030002.named_with_yatori(c)
	local m=_G["c"..c:GetCode()]
	return m and m.halo_yatori
end
function c12030002.cfilter(c,zone)
	local seq=c:GetSequence()
	if c:IsLocation(LOCATION_MZONE) then
		if c:IsControler(1) then seq=seq+16 end
	else
		seq=c:GetPreviousSequence()
		if c:GetPreviousControler()==1 then seq=seq+16 end
	end
	return bit.extract(zone,seq)~=0
end
function c12030002.condition(e,tp,eg,ep,ev,re,r,rp)
	local zone=Duel.GetLinkedZone(0)+(Duel.GetLinkedZone(1)<<0x10)
	return not eg:IsContains(e:GetHandler()) and eg:IsExists(c12030002.cfilter,1,nil,zone)
end
function c12030002.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c12030002.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then 
		 Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c12030002.filter(c)
	return c:CheckSetCard("yatori") and c:IsAbleToHand()
end
function c12030002.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if Duel.GetFlagEffect(tp,12030002)==0 then
	if chk==0 then return Duel.IsExistingMatchingCard(c12030002.filter,tp,LOCATION_DECK,0,1,nil) end
	  e:SetCategory(CATEGORY_SEARCH)
	  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	else
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,nil) end
	  e:SetCategory(CATEGORY_TOGRAVE)
	  Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_ONFIELD)
	end
end
function c12030002.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,12030002)==0 then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c12030002.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	else
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,nil,REASON_EFFECT)
	end
	end
end
function c12030002.drcon(e,tp,eg,ep,ev,re,r,rp)
	e:SetLabel(e:GetHandler():GetPreviousControler())
	return e:GetHandler():IsReason(REASON_EFFECT)
end
function c12030002.filter1(c)
	return c:CheckSetCard("yatori") and c:IsAbleToGrave()
end
function c12030002.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12030002.filter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	if  rp==1-tp and tp==e:GetLabel() then
		Duel.RegisterFlagEffect(tp,12030002+100,RESET_PHASE+PHASE_END,0,1)
		e:SetCategory(CATEGORY_TOHAND)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
	end
end
function c12030002.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c12030002.filter1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end 
	if Duel.GetFlagEffect(tp,12030002)>0 and g:GetFirst():IsAbleToHand() and Duel.SelectYesNo(tp,aux.Stringid(12030002,3)) then
	   Duel.SendtoHand(g,nil,REASON_EFFECT)
	   Duel.ConfirmCards(1-tp,g)
	end
end