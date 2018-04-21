--回转的悲凉 波恋达斯
function c12008014.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--sp1
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12008014,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetCountLimit(1,12008014)
	e2:SetTarget(c12008014.sptg)
	e2:SetOperation(c12008014.spop)
	c:RegisterEffect(e2) 
	--tograve
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(12008014,2))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,12008114)
	e4:SetTarget(c12008014.sptg2)
	e4:SetOperation(c12008014.spop2)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e5)	
end
function c12008014.spfilter(c,e,tp)
	return c:IsFaceup() and c:IsReason(REASON_EFFECT) and c:GetReasonEffect():GetHandler():IsSetCard(0x1fb3) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(12008014)
end
function c12008014.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c12008014.spfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil,e,tp) end
	e:SetLabelObject(nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED)
end
function c12008014.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c12008014.spfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,nil,e,tp)
	if g:GetCount()>0 then
	   Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c12008014.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	e:SetLabel(Duel.AnnounceNumber(tp,2,3,4))
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c12008014.cfilter(c,link)
	return c:GetLink()==link and c:IsAbleToRemove()
end
function c12008014.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.IsChainDisablable(0) then
		local g=Duel.GetMatchingGroup(c12008014.cfilter,tp,0,LOCATION_EXTRA,nil,e:GetLabel())
		if g:GetCount()>=2 and Duel.SelectYesNo(1-tp,aux.Stringid(12008014,1)) then
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_REMOVE)
			local sg=g:Select(1-tp,2,2,nil)
			Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
			Duel.NegateEffect(0)
			return
		end
	end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)<=0 then return end
	local rg=Duel.GetMatchingGroup(c12008014.rmfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if rg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(12008014,3)) then
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)   
	   local rg2=rg:Select(tp,1,1,nil)
	   Duel.Remove(rg2,POS_FACEUP,REASON_EFFECT)
	end
end
function c12008014.rmfilter(c)
	return c:IsType(TYPE_TRAP+TYPE_SPELL) and c:IsAbleToRemove()
end