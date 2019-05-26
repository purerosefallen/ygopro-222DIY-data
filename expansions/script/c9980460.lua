--智脑-帝王的腰带
function c9980460.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9980460+EFFECT_COUNT_CODE_OATH)
	e1:SetCountLimit(1,9980460)
	e1:SetTarget(c9980460.target)
	e1:SetOperation(c9980460.operation)
	c:RegisterEffect(e1)
	--to deck
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,99804600)
	e1:SetTarget(c9980460.tdtg)
	e1:SetOperation(c9980460.tdop)
	c:RegisterEffect(e1)
end
c9980460.fit_monster={9980453,9980454}
function c9980460.dfilter(c)
	return c:IsSetCard(0x2bca) and c:IsLevelAbove(1) and c:IsAbleToGrave()
end
function c9980460.filter(c,e,tp,m,ft)
	if not c:IsSetCard(0x2bca) or bit.band(c:GetType(),0x81)~=0x81
		or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	local mg=m:Filter(Card.IsCanBeRitualMaterial,c,c)
	local dg=Duel.GetMatchingGroup(c9980460.dfilter,tp,LOCATION_DECK,0,nil)
	if ft>0 then
		return mg:CheckWithSumEqual(Card.GetRitualLevel,c:GetLevel(),1,99,c)
			or dg:IsExists(c9980460.dlvfilter,1,nil,tp,mg,c)
	else
		return ft>-1 and mg:IsExists(c9980460.mfilterf,1,nil,tp,mg,dg,c)
	end
end
function c9980460.mfilterf(c,tp,mg,dg,rc)
	if c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5 then
		Duel.SetSelectedCard(c)
		return mg:CheckWithSumEqual(Card.GetRitualLevel,rc:GetLevel(),0,99,rc)
			or dg:IsExists(c9980460.dlvfilter,1,nil,tp,mg,rc,c)
	else return false end
end
function c9980460.dlvfilter(c,tp,mg,rc,mc)
	Duel.SetSelectedCard(Group.FromCards(c,mc))
	return mg:CheckWithSumEqual(Card.GetRitualLevel,rc:GetLevel(),0,99,rc)
end
function c9980460.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp)
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		return Duel.IsExistingMatchingCard(c9980460.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp,mg,ft)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c9980460.activate(e,tp,eg,ep,ev,re,r,rp)
	local m=Duel.GetRitualMaterial(tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c9980460.filter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp,m,ft)
	local tc=tg:GetFirst()
	if tc then
		local mat,dmat
		local mg=m:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		local dg=Duel.GetMatchingGroup(c9980460.dfilter,tp,LOCATION_DECK,0,nil)
		if ft>0 then
			local b1=dg:IsExists(c9980460.dlvfilter,1,nil,tp,mg,tc)
			local b2=mg:CheckWithSumEqual(Card.GetRitualLevel,tc:GetLevel(),1,99,tc)
			if b1 and (not b2 or Duel.SelectYesNo(tp,aux.Stringid(9980460,0))) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
				dmat=dg:FilterSelect(tp,c9980460.dlvfilter,1,1,nil,tp,mg,tc)
				Duel.SetSelectedCard(dmat)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
				mat=mg:SelectWithSumEqual(tp,Card.GetRitualLevel,tc:GetLevel(),0,99,tc)
				mat:Merge(dmat)
			else
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
				mat=mg:SelectWithSumEqual(tp,Card.GetRitualLevel,tc:GetLevel(),1,99,tc)
			end
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			mat=mg:FilterSelect(tp,c9980460.mfilterf,1,1,nil,tp,mg,dg,tc)
			local b1=dg:IsExists(c9980460.dlvfilter,1,nil,tp,mg,tc,mat:GetFirst())
			Duel.SetSelectedCard(mat)
			local b2=mg:CheckWithSumEqual(Card.GetRitualLevel,tc:GetLevel(),0,99,tc)
			if b1 and (not b2 or Duel.SelectYesNo(tp,aux.Stringid(9980460,0))) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
				dmat=dg:FilterSelect(tp,c9980460.dlvfilter,1,1,nil,tp,mg,tc,mat:GetFirst())
				mat:Merge(dmat)
				Duel.SetSelectedCard(mat)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
				local mat2=mg:SelectWithSumEqual(tp,Card.GetRitualLevel,tc:GetLevel(),0,99,tc)
				mat:Merge(mat2)
			else
				Duel.SetSelectedCard(mat)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
				local mat2=mg:SelectWithSumEqual(tp,Card.GetRitualLevel,tc:GetLevel(),0,99,tc)
				mat:Merge(mat2)
			end
		end
		tc:SetMaterial(mat)
		if dmat then
			mat:Sub(dmat)
			Duel.SendtoGrave(dmat,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
		end
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980460,1)) 
end
function c9980460.tdfilter(c)
	return c:IsCode(9980453,9980454) and c:IsAbleToDeck()
end
function c9980460.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c9980460.tdfilter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return e:GetHandler():IsAbleToDeck()
		and Duel.IsExistingTarget(c9980460.tdfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c9980460.tdfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,e:GetHandler())
	g:AddCard(e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c9980460.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
		local g=Group.FromCards(c,tc)
		if Duel.SendtoDeck(g,nil,2,REASON_EFFECT)==0 then return end
		Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980460,1)) 
		Duel.ShuffleDeck(tp)
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
