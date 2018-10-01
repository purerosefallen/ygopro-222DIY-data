--星之骑士协力 拟镜
function c65090011.initial_effect(c)
	--spsummon
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetRange(LOCATION_HAND)
	e0:SetCountLimit(1,65090011)
	e0:SetCondition(c65090011.spcon)
	e0:SetCost(c65090011.spcost)
	e0:SetTarget(c65090011.sptg)
	e0:SetOperation(c65090011.spop)
	c:RegisterEffect(e0)
	Duel.AddCustomActivityCounter(65090011,ACTIVITY_SPSUMMON,c65090011.counterfilter)
	--cannot be battle target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e1:SetCondition(c65090011.atkcon)
	e1:SetValue(aux.imval1)
	c:RegisterEffect(e1)
end
function c65090011.atkcon(e)
	return Duel.IsExistingMatchingCard(aux.TRUE,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,e:GetHandler())
end
function c65090011.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 
end
function c65090011.counterfilter(c)
	return c:IsSetCard(0xda6)
end
function c65090011.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(65090011,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c65090011.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c65090011.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0xda6)
end
function c65090011.spfil(c,e,tp)
	return c:IsCode(65090001) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
end
function c65090011.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>=2 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingMatchingCard(c65090011.spfil,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c65090011.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) then
		if Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c65090011.spfil,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) then
			Duel.BreakEffect()
			local g=Duel.SelectMatchingCard(tp,c65090011.spfil,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end