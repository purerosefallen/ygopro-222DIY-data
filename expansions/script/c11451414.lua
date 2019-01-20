--aoguang,king of dragon palace
function c11451414.initial_effect(c)
	c:EnableReviveLimit()
	--effect1
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11451414,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCountLimit(1,11451404)
	e1:SetCondition(c11451414.condition)
	e1:SetTarget(c11451414.target)
	e1:SetOperation(c11451414.operation)
	c:RegisterEffect(e1)
	--effect2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11451414,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,11451414)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c11451414.condition2)
	e2:SetOperation(c11451414.operation2)
	c:RegisterEffect(e2)
	--check release count
	if not c11451414.global_check then
		c11451414.global_check=true
		c11451414[0]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_RELEASE)
		ge1:SetOperation(c11451414.check)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(c11451414.clear)
		Duel.RegisterEffect(ge2,0)
	end
end
function c11451414.mat_filter(c)
	return c:IsAttribute(ATTRIBUTE_WATER)
end
function c11451414.filter(c,tp)
	return c:IsControler(tp) and c:IsSetCard(0x6978)
end
function c11451414.check(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(Card.IsSetCard,nil,0x6978)
	local g2=g:Filter(Card.IsType,nil,TYPE_MONSTER)
	local count=g2:FilterCount(Card.GetPreviousControler,nil,tp)
	c11451414[0]=c11451414[0]+count
end
function c11451414.clear(e,tp,eg,ep,ev,re,r,rp)
	c11451414[0]=0
end
function c11451414.condition(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(c11451414.filter,1,nil,tp)
		and Duel.IsChainNegatable(ev) and not e:GetHandler():IsPublic() and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,true)
end
function c11451414.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_HAND)
end
function c11451414.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,true) and e:GetHandler():IsLocation(LOCATION_HAND) then
		if Duel.SpecialSummon(e:GetHandler(),SUMMON_TYPE_RITUAL,tp,tp,true,true,POS_FACEUP) then
			e:GetHandler():CompleteProcedure()
		end
	end
end
function c11451414.condition2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end
function c11451414.operation2(e,tp,eg,ep,ev,re,r,rp)
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetCountLimit(1)
	e3:SetCondition(c11451414.condition3)
	e3:SetOperation(c11451414.operation3)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end
function c11451414.condition3(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsType,1-tp,LOCATION_MZONE+LOCATION_HAND,0,nil,TYPE_MONSTER)
	g=g:Filter(Card.IsReleasable,nil)
	return g:GetCount()>0 and c11451414[0]>0
end
function c11451414.operation3(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsType,1-tp,LOCATION_MZONE+LOCATION_HAND,0,nil,TYPE_MONSTER)
	g=g:Filter(Card.IsReleasable,nil)
	local count=math.min(g:GetCount(),c11451414[0])
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_RELEASE)
	local g2=g:Select(1-tp,count,count,nil)
	Duel.HintSelection(g2)
	Duel.Release(g2,REASON_RULE)
end