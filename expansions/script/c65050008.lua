--唤灵缚形 霍克玛
function c65050008.initial_effect(c)
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.ritlimit)
	c:RegisterEffect(e0)
	--contorl
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c65050008.cocost)
	e1:SetTarget(c65050008.cotg)
	e1:SetOperation(c65050008.coop)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_RELEASE)
	e2:SetCountLimit(1,65050008)
	e2:SetTarget(c65050008.sptg)
	e2:SetOperation(c65050008.spop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_LEAVE_FIELD)
	c:RegisterEffect(e3)
end
function c65050008.cocofil(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x3da1) and c:IsReleasable()
end

function c65050008.cocost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65050008.cocofil,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
	local sg=Duel.SelectMatchingCard(tp,c65050008.cocofil,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
	local tc=sg:GetFirst()
	e:SetLabel(tc:GetAttack())
	Duel.Release(sg,REASON_COST)
end
function c65050008.cotg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c65050008.coop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.GetControl(tc,tp)
	end
end
function c65050008.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanSpecialSummonMonster(tp,65050012,0,0x4011,0,0,8,RACE_SPELLCASTER,ATTRIBUTE_LIGHT) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,0)
end
function c65050008.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,65050012,0,0x4011,0,0,8,RACE_SPELLCASTER,ATTRIBUTE_LIGHT) then return end
	local token=Duel.CreateToken(tp,65050012)
	Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(8)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		token:RegisterEffect(e1)
	if Duel.SpecialSummonComplete()~=0 then
		Duel.BreakEffect()
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,3,nil)
		if g:GetCount()>0 then
			Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		end
	end
end