--梦医院的梦之患者
function c71400006.initial_effect(c)
	--summon limit
	local el1=Effect.CreateEffect(c)
	el1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	el1:SetType(EFFECT_TYPE_SINGLE)
	el1:SetCode(EFFECT_CANNOT_SUMMON)
	el1:SetCondition(c71400006.sumlimit)
	c:RegisterEffect(el1)
	local el2=el1:Clone()
	el2:SetCode(EFFECT_CANNOT_MSET)
	c:RegisterEffect(el2)
	local el3=el1:Clone()
	el3:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(el3)
	--summon success
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71400006,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c71400006.target1)
	e1:SetOperation(c71400006.operation1)
	c:RegisterEffect(e1)
	local e1a=e1:Clone()
	e1a:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e1a)
	--self des
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(71400006,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_F)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_BECOME_TARGET)
	e2:SetCondition(c71400006.condition2)
	e2:SetTarget(c71400006.target2)
	e2:SetOperation(c71400006.operation2)
	c:RegisterEffect(e2)
end
function c71400006.lfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3714)
end
function c71400006.sumlimit(e)
	return not Duel.IsExistingMatchingCard(c71400006.lfilter,e:GetHandlerPlayer(),LOCATION_FZONE,0,1,nil)
end
function c71400006.filter1(c,e,tp)
	return c:IsLevelBelow(4) and c:IsSetCard(0x714) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c71400006.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c71400006.filter1(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c71400006.filter1,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c71400006.filter1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,LOCATION_MZONE)
end
function c71400006.operation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE) then
		Duel.SpecialSummonComplete()
		local dg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		if dg:GetCount()>0 then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
			Duel.HintSelection(g)
			Duel.Remove(g:GetFirst(),POS_FACEUP,REASON_EFFECT)
		end
	end
end
function c71400006.condition2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsContains(e:GetHandler())
end
function c71400006.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c71400006.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.Destroy(c,REASON_EFFECT)
	end
end