local m=12026012
local cm=_G["c"..m]
--幸存者的妥协
function cm.initial_effect(c)
	--rec or dam
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,m)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(cm.atktg)
	e2:SetOperation(cm.atkop)
	c:RegisterEffect(e2)
end
cm.lighting_with_Raphael=1
function cm.describe_with_Raphael(c)
	local m=_G["c"..c:GetCode()]
	return m and m.lighting_with_Raphael
end
function cm.filter1(c,e,tp)
	return c:IsSetCard(0x1fbd) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.rfilter(c)
	return (c:IsSetCard(0x1fbd) or c:IsSetCard(0x1fb3) ) and c:IsAbleToRemove() and Duel.IsExistingMatchingCard(cm.rfilter1,tp,LOCATION_DECK,0,1,nil,c:GetRace())
end
function cm.rfilter1(c,race)
	return (c:IsSetCard(0x1fbd) or c:IsSetCard(0x1fb3) ) and c:IsAbleToHand() and c:IsRace(race)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=( Duel.GetFlagEffect(tp,m+100)==0 and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(cm.filter1,tp,LOCATION_DECK,0,1,nil,e,tp) )
	local b2=( Duel.IsExistingMatchingCard(cm.rfilter,tp,LOCATION_GRAVE,0,1,nil)  and Duel.GetFlagEffect(tp,m+200)==0 )  
	if chk==0 then return b1 or b2 end
	local b3=( Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_MZONE,0,1,nil,12009101) and b1 and b2 ) 
	if b1 and b2 and b3 then op=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2),aux.Stringid(m,3))
	elseif b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2))
	elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(m,1))
	elseif b2 then op=Duel.SelectOption(tp,aux.Stringid(m,2))+1
	else return end
	e:SetLabel(op)
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(m,op+1))
	if op==0 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	elseif op==1 then
		e:SetCategory(CATEGORY_SEARCH+CATEGORY_REMOVE)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_GRAVE)
	elseif op==2 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH+CATEGORY_REMOVE)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_GRAVE)
	end
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 or e:GetLabel()==2 then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local rg=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SendtoGrave(rg,REASON_EFFECT)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.filter1,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
	Duel.RegisterFlagEffect(tp,m+100,RESET_PHASE+PHASE_END,0,1)
	end
	if e:GetLabel()==1 or e:GetLabel()==2 then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local cg=Duel.SelectMatchingCard(tp,cm.rfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if cg:GetCount()>0 and Duel.Remove(cg,POS_FACEUP,REASON_EFFECT)>0 then
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	   local hg=Duel.SelectMatchingCard(tp,cm.rfilter1,tp,LOCATION_DECK,0,1,1,nil,cg:GetFirst():GetRace())
		   if hg:GetCount()>0 then 
			   Duel.SendtoHand(hg,nil,REASON_EFFECT)
		   end
	end
	   Duel.RegisterFlagEffect(tp,m+200,RESET_PHASE+PHASE_END,0,1)
	end
end
function cm.tgfilter(c,e,tp)
	return not c:IsCode(m) and cm.describe_with_Raphael(c) and c:IsAbleToHand()
end
function cm.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(cm.tgfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	Duel.SelectTarget(tp,cm.tgfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	Duel.SendtoHand(tc,nil,REASON_EFFECT)
end