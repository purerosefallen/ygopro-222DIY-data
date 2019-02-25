--逐火之蛾 伊瑟琳
function c75646306.initial_effect(c)
	--to grave
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(75646306,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,75646306)
	e1:SetTarget(c75646306.tgtg)
	e1:SetOperation(c75646306.tgop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--remove
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_HAND)
	e3:SetCountLimit(1,5646306)
	e3:SetCondition(c75646306.con) 
	e3:SetTarget(c75646306.target)
	e3:SetOperation(c75646306.operation)
	c:RegisterEffect(e3)
	c75646306.act_effect=e3
end
function c75646306.tgfilter(c)
	return c:IsSetCard(0x62c1) and c:IsAbleToGrave()
end
function c75646306.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75646306.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c75646306.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c75646306.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c75646306.con(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsSetCard(0x62c1) and re:IsHasCategory(CATEGORY_SPECIAL_SUMMON)
end
function c75646306.spfilter(c,e,tp)
	return c:IsSetCard(0x62c1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c75646306.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c75646306.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	local g=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil,0x62c1)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)   
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c75646306.desfilter(c)
	return c:IsSetCard(0x62c1) 
		and (c:IsLocation(LOCATION_HAND) or c:IsFaceup())
end
function c75646306.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c75646306.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local dg=Duel.GetMatchingGroup(c75646306.desfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil)
			if dg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(75646306,0)) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
				local tg=dg:Select(tp,1,1,nil)
				Duel.Destroy(tg,REASON_EFFECT)
			end
		end
	end
end