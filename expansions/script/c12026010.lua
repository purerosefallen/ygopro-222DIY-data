local m=12026010
local cm=_G["c"..m]
--来自白神的指引
function c12026010.initial_effect(c)
	--rec or dam
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12026010,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c12026010.target)
	e1:SetOperation(c12026010.operation)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(c12026010.reptg)
	e2:SetValue(c12026010.repval)
	e2:SetOperation(c12026010.repop)
	c:RegisterEffect(e2)
end
c12026010.lighting_with_Raphael=1
function c12026010.describe_with_Raphael(c)
	local m=_G["c"..c:GetCode()]
	return m and m.lighting_with_Raphael
end
function c12026010.filter1(c)
	return ( c:IsSetCard(0xfbb) or c:IsSetCard(0x1fbd) )and c:IsAbleToHand()
end
function c12026010.cfilter(c,e,tp)
	return c:IsSetCard(0x1fbd) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c12026010.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=( Duel.GetFlagEffect(tp,12026010+100)==0  and Duel.IsExistingMatchingCard(c12026010.filter1,tp,LOCATION_DECK,0,1,nil) )
	local b2=( Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c12026010.cfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetFlagEffect(tp,12026010+200)==0 ) 
	if chk==0 then return b1 or b2 end
	local b3=( Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_MZONE,0,1,nil,12009100)  and b1 and b2 )
	if b1 and b2 and b3 then op=Duel.SelectOption(tp,aux.Stringid(12026010,1),aux.Stringid(12026010,2),aux.Stringid(12026010,3))
	elseif b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(12026010,1),aux.Stringid(12026010,2))
	elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(12026010,1))
	elseif b2 then op=Duel.SelectOption(tp,aux.Stringid(12026010,2))+1
	else return end
	e:SetLabel(op)
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(12026010,op+1))
	if op==0 then
		e:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	elseif op==1 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
	else 
		e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH+CATEGORY_TOHAND)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
	end
end
function c12026010.operation(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 or e:GetLabel()==2 then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c12026010.filter1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	Duel.RegisterFlagEffect(tp,12026010+100,RESET_PHASE+PHASE_END,0,1)
	end
	if e:GetLabel()==1 or e:GetLabel()==2 then
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c12026010.cfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP) 
	end
	Duel.RegisterFlagEffect(tp,12017102+100,RESET_PHASE+PHASE_END,0,1)
	end
end
function c12026010.repfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x1fbd) and c:IsLocation(LOCATION_ONFIELD)
		and c:IsControler(tp)
end
function c12026010.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c12026010.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c12026010.repval(e,c)
	return c12026010.repfilter(c,e:GetHandlerPlayer())
end
function c12026010.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end
