--黄蜂
function c65071050.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetTarget(c65071050.target)
	e1:SetOperation(c65071050.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c65071050.destg)
	e2:SetOperation(c65071050.desop)
	c:RegisterEffect(e2)
end
function c65071050.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
end
function c65071050.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(tc)
		e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
		e1:SetCode(EVENT_TO_GRAVE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetHintTiming(0,TIMING_END_PHASE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetCondition(c65071050.spcon)
		e1:SetTarget(c65071050.sptg)
		e1:SetOperation(c65071050.spop)
		tc:RegisterEffect(e1,true)
		tc:RegisterFlagEffect(0,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(65071050,0))
	end
end
function c65071050.spfil(c)
	return c:IsPreviousLocation(LOCATION_MZONE)
end

function c65071050.spcon(e,tp,eg,ep,ev,re,r,rp,chk)
	return eg:IsExists(c65071050.spfil,1,nil)
end
function c65071050.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,65071156,0,0x4011,2500,1500,6,RACE_INSECT,ATTRIBUTE_WIND,POS_FACEUP_ATTACK,1-tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c65071050.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(1-tp,LOCATION_MZONE)<=0 then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,65071156,0,0x4011,2500,1500,6,RACE_INSECT,ATTRIBUTE_WIND,POS_FACEUP_ATTACK,1-tp) then return end
	local token=Duel.CreateToken(tp,65071156)
	Duel.SpecialSummon(token,0,tp,1-tp,false,false,POS_FACEUP_ATTACK)
end

function c65071050.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsType(TYPE_MONSTER) and chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,65071156,0,0x4011,2500,1500,6,RACE_INSECT,ATTRIBUTE_WIND,POS_FACEUP_DEFENSE) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c65071050.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if Duel.Destroy(tc,REASON_EFFECT)~=0 then
			if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
			if not Duel.IsPlayerCanSpecialSummonMonster(tp,65071156,0,0x4011,2500,1500,6,RACE_INSECT,ATTRIBUTE_WIND,POS_FACEUP_DEFENSE,tp) then return end
			local token=Duel.CreateToken(tp,65071156)
			Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		end
	end
end