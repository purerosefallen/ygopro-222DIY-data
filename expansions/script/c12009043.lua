--歌姬的祝祭 蕾恩缇娅
function c12009043.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12009043,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O) 
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_MAIN_END)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,12009043)
	e1:SetCondition(c12009043.hspcon)
	e1:SetTarget(c12009043.hsptg)
	e1:SetOperation(c12009043.hspop)
	c:RegisterEffect(e1) 
	--synchro effect
	--ritural
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCountLimit(1,12009143)
	e5:SetCost(aux.bfgcost)
	e5:SetTarget(c12009043.sptg)
	e5:SetOperation(c12009043.spop)
	c:RegisterEffect(e5)
	if not c12009043.global_check then
		c12009043.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c12009043.checkop)
		Duel.RegisterEffect(ge1,0)
	end 
end

function c12009043.sumlimit(e,c)
	return c:IsCode(e:GetLabelObject():GetCode())
end
function c12009043.aclimit(e,re,tp)
	local tc=e:GetLabelObject()
	return re:GetHandler():IsCode(tc:GetCode()) and not re:GetHandler():IsImmuneToEffect(e)
end
function c12009043.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tct=Duel.GetTurnCount()
	Duel.RegisterFlagEffect(rp,12009043+tct,RESET_PHASE+PHASE_END,0,2)
end
function c12009043.hspcon(e,tp,eg,ep,ev,re,r,rp)
	local tct=Duel.GetTurnCount()-1
	return Duel.GetFlagEffect(1-tp,12009043+tct)>0 and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function c12009043.hsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c12009043.hspop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0
	end
end
function c12009043.filter(c,e,sp)
	return c:IsCode(12009040) and c:IsCanBeSpecialSummoned(e,0,sp,false,false)
end
function c12009043.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12009043.filter,tp,LOCATION_DECK,0,1,nil,e,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c12009043.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local sc=Duel.GetFirstMatchingCard(c12009043.filter,tp,LOCATION_DECK,0,nil,e,tp)
	if sc then
		Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
	end
end
