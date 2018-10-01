--星之骑士协力 雏鸟
function c65090013.initial_effect(c)
	--spsummon
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetRange(LOCATION_HAND)
	e0:SetCountLimit(1,65090013)
	e0:SetCondition(c65090013.spcon)
	e0:SetCost(c65090013.spcost)
	e0:SetTarget(c65090013.sptg)
	e0:SetOperation(c65090013.spop)
	c:RegisterEffect(e0)
	Duel.AddCustomActivityCounter(65090013,ACTIVITY_SPSUMMON,c65090013.counterfilter)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetCountLimit(1)
	e2:SetCondition(c65090013.condition)
	e2:SetTarget(c65090013.target2)
	e2:SetOperation(c65090013.activate)
	c:RegisterEffect(e2)
end
function c65090013.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end
function c65090013.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=Duel.GetAttacker()
	if chk==0 then return tg:IsOnField() and tg:IsCanBeEffectTarget(e) end
end
function c65090013.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	if tc and tc:IsFaceup() and tc:IsRelateToBattle() then
		Duel.NegateAttack()
	end
end
function c65090013.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 
end
function c65090013.counterfilter(c)
	return c:IsSetCard(0xda6)
end
function c65090013.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(65090013,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c65090013.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c65090013.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0xda6)
end
function c65090013.spfil(c,e,tp)
	return c:IsCode(65090001) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
end
function c65090013.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>=2 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingMatchingCard(c65090013.spfil,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c65090013.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) then
		if Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c65090013.spfil,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) then
			Duel.BreakEffect()
			local g=Duel.SelectMatchingCard(tp,c65090013.spfil,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end