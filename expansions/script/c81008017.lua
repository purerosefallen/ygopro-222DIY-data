--花明夜风·盐见周子
function c81008017.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,81008017)
	e1:SetCondition(c81008017.spcon)
	e1:SetCost(c81008017.spcost)
	e1:SetTarget(c81008017.sptg)
	e1:SetOperation(c81008017.spop)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(81008017,ACTIVITY_SPSUMMON,c81008017.counterfilter)
end
function c81008017.counterfilter(c)
	return c:IsRace(RACE_ZOMBIE)
end
function c81008017.cfilter(c,tp)
	return c:IsRace(RACE_ZOMBIE) and c:IsLinkAbove(4) and c:GetSummonLocation()==LOCATION_EXTRA and c:IsControler(tp)
end
function c81008017.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c81008017.cfilter,1,nil,tp)
end
function c81008017.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(81008017,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c81008017.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c81008017.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c81008017.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c81008017.splimit(e,c,sump,sumtype,sumpos,targetp)
	return c:IsLocation(LOCATION_EXTRA) and not c:IsSetCard(0x121)
end
