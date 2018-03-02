--水歌 原奏的丝特米亚
function c12003016.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_SEASERPENT),3)
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(12003016,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCost(c12003016.cost)
	e4:SetHintTiming(0,TIMING_END_PHASE+TIMING_EQUIP)
	e4:SetCondition(c12003016.con)
	e4:SetOperation(c12003016.spop)
	c:RegisterEffect(e4)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c12003016.incon1)
	e3:SetTarget(c12003016.target)
	e3:SetValue(c12003016.efilter)
	c:RegisterEffect(e3)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c12003016.incon2)
	e1:SetValue(1)
	c:RegisterEffect(e1) 
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	c:RegisterEffect(e2)
	--negate
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(12003016,1))
	e4:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCost(c12003016.spcost)
	e4:SetCondition(c12003016.incon3)
	e4:SetTarget(c12003016.negtg)
	e4:SetOperation(c12003016.negop)
	c:RegisterEffect(e4)
end
function c12003016.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,12003016)==0 end
	Duel.RegisterFlagEffect(tp,12003016,RESET_CHAIN,0,1)
end
function c12003016.incon1(e,c,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetLinkedGroupCount()>=1
end
function c12003016.incon2(e,c,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetLinkedGroupCount()>=2
end
function c12003016.incon3(e,c,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetLinkedGroupCount()>=3 and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c12003016.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return re:GetHandler():IsAbleToRemove() end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end
function c12003016.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	end
end
function c12003016.target(e,c)
	local g,te=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS,CHAININFO_TRIGGERING_EFFECT)
	return not (te and te:IsHasProperty(EFFECT_FLAG_CARD_TARGET))
		or not (g and g:IsContains(c))
end
function c12003016.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end

function c12003016.cfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsControler(tp)
end
function c12003016.con(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetLinkedGroup():FilterCount(c12003016.cfilter,nil,tp)==0 and Duel.GetTurnPlayer()==1-tp then return true end
end
function c12003016.cfilter1(c,g)
	return c:IsType(TYPE_MONSTER) and g:IsContains(c)
end
function c12003016.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local lg=e:GetHandler():GetLinkedGroup()
	if chk==0 then return Duel.CheckReleaseGroup(tp,c12003016.cfilter,1,nil,lg) end
	local g=Duel.SelectReleaseGroup(tp,c12003016.cfilter1,1,1,nil,lg)
	Duel.Release(g,REASON_COST)
end
function c12003016.spfilter(c,e,tp,zone)
	return c:IsRace(RACE_SEASERPENT) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone,true)
end
function c12003016.spop(e,tp,eg,ep,ev,re,r,rp)
	local zone=e:GetHandler():GetLinkedZone()
	if chk==0 then return zone~=0
		and Duel.IsExistingMatchingCard(c12003016.spfilter,tp,LOCATION_GRAVE,0,3,nil,e,tp,zone) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c12003016.spfilter,tp,LOCATION_GRAVE,0,3,3,nil,e,tp,zone)
	local tc=g:GetFirst()
	while tc do
		  if tc:IsRelateToEffect(e) and zone~=0 then
			  Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP,zone) end
		  tc=g:GetNext()
	end
end