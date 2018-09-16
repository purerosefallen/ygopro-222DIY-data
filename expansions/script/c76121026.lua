--神论之访
function c76121026.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(76121026,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c76121026.thtg)
	e1:SetOperation(c76121026.thop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(76121026,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c76121026.ssetcost)
	e2:SetTarget(c76121026.ssettg)
	e2:SetOperation(c76121026.ssetop)
	c:RegisterEffect(e2)
end
function c76121026.cfilter(c,tp)
	local dg=Duel.GetMatchingGroup(c76121026.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,c,c:GetCode())
	return c:IsSetCard(0xea2) and c:IsType(TYPE_MONSTER) and c:IsReleasable()
		and dg:GetClassCount(Card.GetCode)>=2
end
function c76121026.thfilter(c,code)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xea2) and not c:IsCode(code) and c:IsAbleToHand()
end
function c76121026.sfilter(c)
	return c:IsMSetable(true,nil)
end
function c76121026.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.CheckReleaseGroupEx(tp,c76121026.cfilter,1,nil,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectReleaseGroupEx(tp,c76121026.cfilter,1,1,nil,tp)
	e:SetLabelObject(g:GetFirst())
	Duel.Release(g,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c76121026.thop(e,tp,eg,ep,ev,re,r,rp)
	local sc=e:GetLabelObject()
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c76121026.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,sc,sc:GetCode())
	if g:GetClassCount(Card.GetCode)>=2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local hg1=g:Select(tp,1,1,nil)
		g:Remove(Card.IsCode,nil,hg1:GetFirst():GetCode())
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local hg2=g:Select(tp,1,1,nil)
		hg1:Merge(hg2)
		if Duel.SendtoHand(hg1,nil,REASON_EFFECT)>0 then
			Duel.ConfirmCards(1-tp,hg1)
			if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c76121026.sfilter,tp,LOCATION_HAND,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(76121026,2)) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
				local sg=Duel.SelectMatchingCard(tp,c76121026.sfilter,tp,LOCATION_HAND,0,1,1,nil)
				local tc=sg:GetFirst()
				if tc then
					Duel.MSet(tp,tc,true,nil)
				end
			end
		end
	end
end
function c76121026.ssetcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c76121026.ssetfilter(c)
	return c:IsSetCard(0xea2) and c:IsType(TYPE_TRAP) and c:IsSSetable() and not c:IsCode(76121026)
end
function c76121026.ssettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c76121026.ssetfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c76121026.ssetop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c76121026.ssetfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g:GetFirst())
		Duel.ConfirmCards(1-tp,g)
	end
end