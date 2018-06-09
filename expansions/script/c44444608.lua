--魂印龙 Earth
function c44444608.initial_effect(c)
	--spirit
	aux.EnableSpiritReturn(c,EVENT_SUMMON_SUCCESS,EVENT_FLIP)
   	--cannot special summon
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e3)
	--summon
	local e12=Effect.CreateEffect(c)
	e12:SetDescription(aux.Stringid(44444608,0))
	e12:SetCountLimit(1,44444608)
	e12:SetHintTiming(TIMING_BATTLE_PHASE,0x1c0+TIMING_BATTLE_PHASE)
	e12:SetCategory(CATEGORY_SUMMON)
	e12:SetType(EFFECT_TYPE_QUICK_O)
	e12:SetCode(EVENT_FREE_CHAIN)
	e12:SetRange(LOCATION_HAND)
    e12:SetCondition(c44444608.spcon)
	e12:SetTarget(c44444608.target)
	e12:SetOperation(c44444608.operation)
	c:RegisterEffect(e12)
	--tohand
	local e14=Effect.CreateEffect(c)
	e14:SetDescription(aux.Stringid(44444608,1))
	e14:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e14:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e14:SetProperty(EFFECT_FLAG_DELAY)
	e14:SetCountLimit(1,99999668)
	e14:SetCode(EVENT_LEAVE_FIELD)
	e14:SetCondition(c44444608.scon)
	e14:SetTarget(c44444608.thtg)
	e14:SetOperation(c44444608.thop)
	c:RegisterEffect(e14)
    --disable search
	local e31=Effect.CreateEffect(c)
	e31:SetType(EFFECT_TYPE_FIELD)
	e31:SetCode(EFFECT_CANNOT_TO_HAND)
	e31:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e31:SetRange(LOCATION_MZONE)
	e31:SetTargetRange(0,1)
	c:RegisterEffect(e31)
	--
	local e41=Effect.CreateEffect(c)
	e41:SetType(EFFECT_TYPE_FIELD)
	e41:SetCode(EFFECT_CANNOT_TO_GRAVE)
	e41:SetRange(LOCATION_MZONE)
	e41:SetTargetRange(0,LOCATION_DECK)
	c:RegisterEffect(e41)
	--
	local e42=Effect.CreateEffect(c)
	e42:SetType(EFFECT_TYPE_FIELD)
	e42:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e42:SetCode(EFFECT_CANNOT_DISCARD_DECK)
	e42:SetRange(LOCATION_MZONE)
	e42:SetTargetRange(0,1)
	c:RegisterEffect(e42)
end
--速攻召唤
function c44444608.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0 

end
function c44444608.spfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsReleasable()
end
function c44444608.spfilter1(c)
	return c:IsType(TYPE_MONSTER)
end
function c44444608.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroupCount(c44444608.spfilter1,tp,LOCATION_MZONE,0,nil)
	if g>1 then g=1 end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
	and Duel.CheckReleaseGroup(tp,c44444608.spfilter,1,e:GetHandler())
	and e:GetHandler():IsSummonable(true,e) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,e:GetHandler(),1,0,0)
end
function c44444608.operation(e,tp,eg,ep,ev,re,r,rp)
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
--回收墓地魂印
function c44444608.scon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not c:IsReason(REASON_BATTLE) 
	and Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_EXTRA,0,nil,TYPE_MONSTER)<=1
end

function c44444608.filter(c)
	return c:IsType(TYPE_MONSTER) 
	and c:IsAbleToHand() 
    and c:IsSetCard(0x907)
	and not c:IsCode(44444608) 
end
function c44444608.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c44444608.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c44444608.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c44444608.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end