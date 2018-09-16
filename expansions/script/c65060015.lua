--draem zouming
function c65060015.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,65060015)
	e1:SetCondition(c65060015.spcon)
	e1:SetCost(c65060015.spcos)
	e1:SetTarget(c65060015.sptg)
	e1:SetOperation(c65060015.spop)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCondition(c65060015.indcon)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x6da4))
	e2:SetValue(1)
	c:RegisterEffect(e2)
end

function c65060015.spcon(e)
	return e:GetHandler():GetAttack()<=1000 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end

function c65060015.spcos(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetReset(RESET_EVENT+0x1fe0000)
	e2:SetValue(300)
	c:RegisterEffect(e2)
end

function c65060015.spfil(c,e,tp)
	return c:IsSetCard(0x6da4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(65060015)
end
function c65060015.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65060015.spfil,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c65060015.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c65060015.spfil,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c65060015.indcon(e)
	return e:GetHandler():GetAttack()<=700
end