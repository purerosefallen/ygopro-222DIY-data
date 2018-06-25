--魂印龙·Dimension
function c44444610.initial_effect(c)
	--spirit
	aux.EnableSpiritReturn(c,EVENT_SUMMON_SUCCESS,EVENT_FLIP)
	--disable spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,1)
	c:RegisterEffect(e2)
   	--cannot special summon
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e3)
	--summon
	local e12=Effect.CreateEffect(c)
	e12:SetDescription(aux.Stringid(44444610,0))
	e12:SetCountLimit(1,44444610)
	e12:SetHintTiming(TIMING_BATTLE_PHASE,0x1c0+TIMING_BATTLE_PHASE)
	e12:SetCategory(CATEGORY_SUMMON)
	e12:SetType(EFFECT_TYPE_QUICK_O)
	e12:SetCode(EVENT_FREE_CHAIN)
	e12:SetRange(LOCATION_HAND)
    e12:SetCondition(c44444610.spcon)
	e12:SetTarget(c44444610.target)
	e12:SetOperation(c44444610.operation)
	c:RegisterEffect(e12)
    --add counter
	local e14=Effect.CreateEffect(c)
	e14:SetDescription(aux.Stringid(44444610,1))

	e14:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e14:SetProperty(EFFECT_FLAG_DELAY)
	e14:SetCode(EVENT_LEAVE_FIELD)
	e14:SetCondition(c44444610.scon)
	e14:SetTarget(c44444610.adtg)
	e14:SetOperation(c44444610.adop)
	c:RegisterEffect(e14)


end
--速攻召唤
function c44444610.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c44444610.cfilter,tp,0,LOCATION_MZONE,1,nil)
    and Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_EXTRA,0,nil,TYPE_MONSTER)<=1
end
function c44444610.cfilter(c)
	return c:IsPosition(POS_FACEUP_ATTACK) and c:IsType(TYPE_EFFECT)
end
function c44444610.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetTurnPlayer()~=tp
	and e:GetHandler():IsSummonable(true,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,e:GetHandler(),1,0,0)
end
function c44444610.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
		if c:IsSummonable(true,nil) then
	    Duel.Summon(tp,c,true,nil)
	    local e4=Effect.CreateEffect(c)
        e4:SetType(EFFECT_TYPE_SINGLE)
        e4:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
        e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
        e4:SetReset(RESET_EVENT+0x1fe0000)
        c:RegisterEffect(e4,true)
	end
end
--设置指示物
function c44444610.scon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not c:IsReason(REASON_BATTLE) 
	and Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_EXTRA,0,nil,TYPE_MONSTER)<=1
end
function c44444610.adtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsCanAddCounter(0x1080,1) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsCanAddCounter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,0x1080,1) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsCanAddCounter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,0x1080,1)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0)
end
function c44444610.adop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsCanAddCounter(0x1080,1) then
		tc:AddCounter(0x1080,1)
	end
end