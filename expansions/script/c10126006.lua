--反骨神具 卡迦迪亚
function c10126006.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10126006,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,10126006)
	e1:SetTarget(c10126006.target)
	e1:SetOperation(c10126006.activate)
	c:RegisterEffect(e1)  
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10126006,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCountLimit(1,10126106)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,0x1028)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCost(c10126006.incost)
	e2:SetCondition(c10126006.incon)
	e2:SetOperation(c10126006.inop)
	c:RegisterEffect(e2)
	--equip
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10126006,2))
	e3:SetCategory(CATEGORY_EQUIP+CATEGORY_TOHAND)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,10126206)
	e3:SetCondition(c10126006.thcon)
	e3:SetTarget(c10126006.thtg)
	e3:SetOperation(c10126006.thop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_RELEASE)
	e4:SetCondition(c10126006.thcon2)
	c:RegisterEffect(e4)
end
function c10126006.thcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not c:IsLocation(LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c10126006.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD) or c:IsReason(REASON_RELEASE)
end
function c10126006.efilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x1335) and Duel.IsExistingMatchingCard(c10126006.efilter2,tp,LOCATION_HAND,0,1,nil,c)
end
function c10126006.efilter2(c,ec)
	return c:IsType(TYPE_EQUIP) and c:CheckEquipTarget(ec)
end
function c10126006.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,e:GetHandler():GetLocation())
end
function c10126006.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoHand(c,nil,REASON_EFFECT)~=0 and c:IsLocation(LOCATION_HAND) then
	   local g=Duel.GetMatchingGroup(c10126006.efilter,tp,LOCATION_MZONE,0,nil,tp)
	   if g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(10126006,3)) then
		  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
		  local tc=g:Select(tp,1,1,nil):GetFirst()
		  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		  local tc2=Duel.SelectMatchingCard(tp,c10126006.efilter2,tp,LOCATION_HAND,0,1,1,nil,tc):GetFirst()
		  Duel.Equip(tp,tc2,tc)
	   end
	end
end
function c10126006.incon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetEquipTarget()
end
function c10126006.incost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHandAsCost() end
	Duel.SendtoHand(e:GetHandler(),nil,REASON_COST)
end
function c10126006.inop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=c:GetPreviousEquipTarget()
	if not ec:IsRelateToEffect(e) or ec:IsFacedown() then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e1:SetValue(1)
	ec:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	ec:RegisterEffect(e2)
end
function c10126006.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c10126006.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_HAND)
end
function c10126006.spfilter(c,e,tp)
	return c:IsSetCard(0x1335) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10126006.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c10126006.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp):GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.Equip(tp,c,tc) then
	   local e1=Effect.CreateEffect(tc)
	   e1:SetType(EFFECT_TYPE_SINGLE)
	   e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	   e1:SetCode(EFFECT_EQUIP_LIMIT)
	   e1:SetValue(c10126006.eqlimit)
	   e1:SetReset(RESET_EVENT+0x1fe0000)
	   c:RegisterEffect(e1)
	end
end
function c10126006.eqlimit(e,c)
	return e:GetOwner()==c
end