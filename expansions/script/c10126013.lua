--神匠器 鹰目
function c10126013.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c10126013.eqtg)
	e1:SetOperation(c10126013.eqop)
	c:RegisterEffect(e1)  
	--Equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(c10126013.eqlimit)
	c:RegisterEffect(e2) 
	--atk
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(1000)
	c:RegisterEffect(e3)
	--Actlimit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetTargetRange(0,1)
	e4:SetValue(c10126013.aclimit)
	e4:SetCondition(c10126013.actcon)
	c:RegisterEffect(e4)
	--actlimit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(0,1)
	e4:SetValue(c10126013.aclimit)
	e4:SetCondition(c10126013.actcon)
	c:RegisterEffect(e4)
	--tribute summon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(10126013,0))
	e5:SetCategory(CATEGORY_SUMMON)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetHintTiming(0,TIMING_MAIN_END)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCountLimit(1,10126013)
	e5:SetCondition(c10126013.sumcon)
	e5:SetTarget(c10126013.sumtg)
	e5:SetOperation(c10126013.sumop)
	c:RegisterEffect(e5)
	--equip
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(10126013,1))
	e6:SetCategory(CATEGORY_EQUIP+CATEGORY_TOHAND)
	e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_TO_GRAVE)
	e6:SetCountLimit(1,10126113)
	e6:SetCondition(c10126013.thcon)
	e6:SetTarget(c10126013.thtg)
	e6:SetOperation(c10126013.thop)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCondition(c10126013.thcon2)
	e7:SetCode(EVENT_RELEASE)
	c:RegisterEffect(e7)
end
function c10126013.eqlimit(e,c)
	return c:IsSetCard(0x1335)
end
function c10126013.thcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not c:IsLocation(LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c10126013.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD) or c:IsReason(REASON_RELEASE)
end
function c10126013.efilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x1335) and Duel.IsExistingMatchingCard(c10126013.efilter2,tp,LOCATION_HAND,0,1,nil,c)
end
function c10126013.efilter2(c,ec)
	return c:IsType(TYPE_EQUIP) and c:CheckEquipTarget(ec)
end
function c10126013.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,e:GetHandler():GetLocation())
end
function c10126013.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoHand(c,nil,REASON_EFFECT)~=0 and c:IsLocation(LOCATION_HAND) then
	   local g=Duel.GetMatchingGroup(c10126013.efilter,tp,LOCATION_MZONE,0,nil,tp)
	   if g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(10126013,2)) then
		  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
		  local tc=g:Select(tp,1,1,nil):GetFirst()
		  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		  local tc2=Duel.SelectMatchingCard(tp,c10126013.efilter2,tp,LOCATION_HAND,0,1,1,nil,tc):GetFirst()
		  Duel.Equip(tp,tc2,tc)
	   end
	end
end
function c10126013.sumcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function c10126013.sumfilter(c)
	return c:IsSetCard(0x1335) and c:IsSummonable(true,nil,1)
end
function c10126013.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10126013.sumfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.RegisterFlagEffect(tp,c10126013,RESET_PHASE+PHASE_END,0,1)
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c10126013.sumop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local tc=Duel.SelectMatchingCard(tp,c10126013.sumfilter,tp,LOCATION_HAND,0,1,1,nil):GetFirst()
	if tc then
	   Duel.Summon(tp,tc,true,nil,1)
	end
end
function c10126013.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c10126013.actcon(e)
	local tc=e:GetHandler():GetEquipTarget()
	return Duel.GetAttacker()==tc or Duel.GetAttackTarget()==tc
end
function c10126013.eqfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x1335)
end
function c10126013.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c10126013.eqfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10126013.eqfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c10126013.eqfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c10126013.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
	   Duel.Equip(tp,c,tc)
	end
end