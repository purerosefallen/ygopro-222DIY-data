--天启之御龙士
function c11115019.initial_effect(c)
    c:SetSPSummonOnce(11115019)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA+LOCATION_GRAVE)
	e2:SetCondition(c11115019.spcon)
	e2:SetOperation(c11115019.spop)
	c:RegisterEffect(e2)
	--level up
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(11115019,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c11115019.lvtg)
	e3:SetOperation(c11115019.lvop)
	c:RegisterEffect(e3)
	--accelerate synchro
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(11115019,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,0x1c0+TIMING_MAIN_END)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c11115019.sccon)
	e4:SetTarget(c11115019.sctg)
	e4:SetOperation(c11115019.scop)
	c:RegisterEffect(e4)
end
function c11115019.spfilter1(c,tp,sc)
	return c:IsSetCard(0xa15e) and c:IsType(TYPE_SYNCHRO) and c:IsControler(tp) and Duel.GetLocationCountFromEx(tp,tp,sc,c)>0
end
function c11115019.spfilter2(c)
	return c:IsSetCard(0xa15e) and c:IsType(TYPE_SYNCHRO) and c:IsAbleToRemoveAsCost()
end
function c11115019.spcon(e,c)
	if c==nil then return true end
	if c:IsLocation(LOCATION_EXTRA) then
	    return Duel.CheckReleaseGroup(c:GetControler(),c11115019.spfilter1,1,nil,c:GetControler(),c)
	else
	    return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		    and Duel.IsExistingMatchingCard(c11115019.spfilter2,c:GetControler(),LOCATION_GRAVE,0,1,nil)
    end	
end
function c11115019.spop(e,tp,eg,ep,ev,re,r,rp,c)
    if c:IsLocation(LOCATION_EXTRA) then
	    local g=Duel.SelectReleaseGroup(tp,c11115019.spfilter1,1,1,nil,tp,c)
	    Duel.Release(g,REASON_COST)
	else
	    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,c11115019.spfilter2,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.Remove(g,POS_FACEUP,REASON_COST)
	end
end
function c11115019.lvfilter(c)
	return c:IsSetCard(0x215e) and c:IsType(TYPE_MONSTER) and c:IsReleasableByEffect()
end
function c11115019.lvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupEx(tp,c11115019.lvfilter,1,e:GetHandler()) end
end
function c11115019.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rg=Duel.SelectReleaseGroupEx(tp,c11115019.lvfilter,1,60,nil)
	local ct=Duel.Release(rg,REASON_EFFECT)
	if ct>0 and c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		e1:SetValue(ct)
		c:RegisterEffect(e1)
	end
end
function c11115019.sccon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return not e:GetHandler():IsStatus(STATUS_CHAINING) and Duel.GetTurnPlayer()~=tp
		and (ph==PHASE_MAIN1 or (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE) or ph==PHASE_MAIN2)
end
function c11115019.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,nil,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c11115019.scop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetControler()~=tp or not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,nil,c)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SynchroSummon(tp,sg:GetFirst(),c)
	end
end