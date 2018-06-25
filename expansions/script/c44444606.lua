--魂印龙 vitallity
function c44444606.initial_effect(c)
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
	e12:SetDescription(aux.Stringid(44444606,1))
	e12:SetCountLimit(1,44444606)
	e12:SetHintTiming(TIMING_BATTLE_PHASE,0x1c0+TIMING_BATTLE_PHASE)
	e12:SetCategory(CATEGORY_SUMMON)
	e12:SetType(EFFECT_TYPE_QUICK_O)
	e12:SetCode(EVENT_FREE_CHAIN)
	e12:SetRange(LOCATION_HAND)
    e12:SetCondition(c44444606.spcon)

	e12:SetTarget(c44444606.target)
	e12:SetOperation(c44444606.operation)
	c:RegisterEffect(e12)
	--to hand
	local e22=Effect.CreateEffect(c)
	e22:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e22:SetType(EFFECT_TYPE_QUICK_O)
	e22:SetCode(EVENT_FREE_CHAIN)
	e22:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e22:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e22:SetCountLimit(1,99999666)
	e22:SetCondition(c44444606.condition)
	e22:SetCost(c44444606.scost)
	e22:SetTarget(c44444606.thtg)
	e22:SetOperation(c44444606.thop)
	c:RegisterEffect(e22)
end
--速攻召唤
function c44444606.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c44444606.cfilter,tp,0,LOCATION_MZONE,1,nil)
    and Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_EXTRA,0,nil,TYPE_MONSTER)<=1
end
function c44444606.cfilter(c)
	return c:IsPosition(POS_FACEUP_ATTACK) and c:IsType(TYPE_EFFECT)
end
function c44444606.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			--and Duel.GetTurnPlayer()~=tp 
		and e:GetHandler():IsSummonable(true,nil) end

	Duel.SetOperationInfo(0,CATEGORY_SUMMON,e:GetHandler(),1,0,0)
end
function c44444606.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Summon(tp,c,true,nil)
end
--检索魂印
function c44444606.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_EXTRA,0,nil,TYPE_MONSTER)<=1
end
function c44444606.costfilter1(c)
	return c:IsAbleToHandAsCost()
end
function c44444606.scost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c44444606.costfilter1,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOHAND)
	local g=Duel.SelectMatchingCard(tp,c44444606.costfilter1,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SendtoHand(g,nil,2,REASON_COST)
end
function c44444606.filter(c)
	return c:IsType(TYPE_MONSTER) 
	and c:IsAbleToHand() 
    and c:IsSetCard(0x907)
	and not c:IsCode(44444606) 
end
function c44444606.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c44444606.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c44444606.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c44444606.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end