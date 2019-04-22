--终景呼唤的荣耀
function c65030065.initial_effect(c)
	 --synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x6da2),aux.NonTuner(Card.IsSetCard,0x6da2),1)
	c:EnableReviveLimit()
	--effect gain
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c65030065.regcon)
	e1:SetOperation(c65030065.regop)
	c:RegisterEffect(e1)
end
function c65030065.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c65030065.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetMaterialCount()
	local ctt=c:GetMaterial():FilterCount(Card.IsType,nil,TYPE_SYNCHRO)
	if ct>=2 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetRange(LOCATION_MZONE)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetTarget(c65030065.e1tg)
		e1:SetValue(500)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e2:SetValue(1)
		c:RegisterEffect(e2)
		local e4=e2:Clone()
		e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		c:RegisterEffect(e4)
		c:RegisterFlagEffect(0,RESET_EVENT+EVENT_LEAVE_FIELD_P,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(65030065,0))
	end
	if ct>=3 then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetTargetRange(LOCATION_MZONE,0)
		e2:SetTarget(c65030065.e1tg)
		e2:SetValue(1)
		c:RegisterEffect(e2)
		local e4=e2:Clone()
		e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		c:RegisterEffect(e4)
		c:RegisterFlagEffect(0,RESET_EVENT+EVENT_LEAVE_FIELD_P,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(65030065,1))
	end
	if ctt>=1 then
		--act limit
		local e3=Effect.CreateEffect(c)
		e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
		e3:SetCode(EVENT_REMOVE)
		e3:SetRange(LOCATION_MZONE)
		e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
		e3:SetCountLimit(1)
		e3:SetCondition(c65030065.con)
		e3:SetTarget(c65030065.tg)
		e3:SetOperation(c65030065.op)
		c:RegisterEffect(e3)
		c:RegisterFlagEffect(0,RESET_EVENT+EVENT_LEAVE_FIELD_P,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(65030065,2))
	end
end
function c65030065.e1tg(e,c)
	return c:IsSetCard(0x6da2) and c:IsFaceup()
end
function c65030065.confil(c,tp)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp and c:IsSetCard(0x6da2)
end
function c65030065.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c65030065.confil,1,nil,tp)
end
function c65030065.tgfil(c,e,tp)
	return c:IsSetCard(0x6da2) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c65030065.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65030065.tgfil,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c65030065.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local g=Duel.SelectMatchingCard(tp,c65030065.tgfil,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end