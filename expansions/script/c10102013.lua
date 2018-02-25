--圣谕圣女 莉兹
function c10102013.initial_effect(c)
	c:EnableReviveLimit()
	--synchro summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10102013,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(aux.SynCondition(nil,aux.NonTuner(nil),1,99))
	e1:SetTarget(aux.SynTarget(nil,aux.NonTuner(nil),1,99))
	e1:SetOperation(aux.SynOperation(nil,aux.NonTuner(nil),1,99))
	e1:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10102013,1))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c10102013.spcon)
	e2:SetOperation(c10102013.spop)
	c:RegisterEffect(e2)
	--cannot special summon
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetRange(LOCATION_EXTRA)
	e3:SetCode(EFFECT_SPSUMMON_CONDITION)
	e3:SetValue(aux.synlimit)
	c:RegisterEffect(e3)
	--SpecialSummon
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetDescription(aux.Stringid(10102013,2))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetHintTiming(0,TIMING_END_PHASE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,10102013)
	e4:SetCost(c10102013.spcost)
	e4:SetTarget(c10102013.sptg)
	e4:SetOperation(c10102013.spop2)
	c:RegisterEffect(e4) 
	c10102013[c]=e4  
end
function c10102013.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c10102013.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0x9330)
end
function c10102013.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc,ec)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c10102013.spfilter(chkc,e,tp) and chkc~=ec end
	if chk==0 then return Duel.IsExistingTarget(c10102013.spfilter,tp,LOCATION_REMOVED,0,2,ec,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>=1 and e:GetHandler():GetFlagEffect(10102013)==0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c10102013.spfilter,tp,LOCATION_REMOVED,0,2,2,ec,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),tp,LOCATION_REMOVED)   
end
function c10102013.spop2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
	   Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c10102013.matfilter(c,fc)
	return c:IsSetCard(0x9330)
		and c:IsAbleToRemoveAsCost() and c:IsCanBeSynchroMaterial(fc)
end
function c10102013.spfilter1(c,tp,g)
	return g:IsExists(c10102013.spfilter2,1,c,tp,c)
end
function c10102013.spfilter2(c,tp,mc)
	return c:GetCode()~=mc:GetCode()
		and Duel.GetLocationCountFromEx(tp,tp,Group.FromCards(c,mc))>0
end
function c10102013.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c10102013.matfilter,tp,LOCATION_MZONE,0,nil,c)
	return g:IsExists(c10102013.spfilter1,1,nil,tp,g)
end
function c10102013.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c10102013.matfilter,tp,LOCATION_MZONE,0,nil,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=g:FilterSelect(tp,c10102013.spfilter1,1,1,nil,tp,g)
	local mc=g1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=g:FilterSelect(tp,c10102013.spfilter2,1,1,mc,tp,mc)
	g1:Merge(g2)
	c:SetMaterial(g1)
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
end