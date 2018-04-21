--天顶的思恋 波恋达斯
function c12008000.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12008000,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,12008000)
	e1:SetTarget(c12008000.sptg)
	e1:SetOperation(c12008000.spop)
	c:RegisterEffect(e1)  
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12008000,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,12008100)
	e2:SetTarget(c12008000.thtg)
	e2:SetOperation(c12008000.thop)
	c:RegisterEffect(e2)  
	local e3=e2:Clone()
	e3:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e3)  
end
function c12008000.thfilter(c)
	return c:IsSetCard(0x1fb3) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and not c:IsRace(RACE_SEASERPENT)
end
function c12008000.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12008000.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c12008000.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c12008000.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
	   Duel.SendtoHand(g,nil,REASON_EFFECT)
	   Duel.ConfirmCards(1-tp,g)
	end
end
function c12008000.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
	e:SetLabel(Duel.AnnounceType(tp))
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,0,0,0)
end
function c12008000.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if g:GetCount()<=0 then return end
	Duel.ConfirmCards(tp,g)
	Duel.ShuffleHand(1-tp)
	local ct1=g:FilterCount(Card.IsType,nil,TYPE_MONSTER)
	local ct2=g:FilterCount(Card.IsType,nil,TYPE_SPELL)
	local ct3=g:FilterCount(Card.IsType,nil,TYPE_TRAP)
	local opt=e:GetLabel()
	local maxct=math.max(ct1,ct2,ct3)
	if (opt==0 and maxct==ct1) or (opt==1 and maxct==ct2) or (opt==2 and maxct==ct3) then
	   if not c:IsRelateToEffect(e) or Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)<=0 then return end
	   local rg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,c)
	   if rg:GetCount()<=0 then return end
	   Duel.BreakEffect()
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	   local tc=rg:Select(tp,1,1,nil):GetFirst()
	   if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)<=0 then return end
	   local e1=Effect.CreateEffect(c)
	   e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	   e1:SetCode(EVENT_PHASE+PHASE_END)
	   e1:SetReset(RESET_PHASE+PHASE_END)
	   e1:SetLabelObject(tc)
	   e1:SetCountLimit(1)
	   e1:SetOperation(c12008000.retop)
	   Duel.RegisterEffect(e1,tp)
	end
end
function c12008000.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
