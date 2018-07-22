--深海的回鸣
function c12009045.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c12009045.target)
	e1:SetOperation(c12009045.activate)
	c:RegisterEffect(e1)  
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetDescription(aux.Stringid(12009045,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(aux.exccon)
	e2:SetCost(c12009045.tdcost)
	e2:SetTarget(c12009045.tdtg)
	e2:SetOperation(c12009045.tdop)
	c:RegisterEffect(e2)  
end
c12009045.fit_monster={12009044}
function c12009045.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12009045.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c12009045.cfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c12009045.cfilter(c)
	return c:IsDiscardable() and c:IsDefense(0)
end
function c12009045.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) and e:GetHandler():IsAbleToDeck() end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,tp,LOCATION_GRAVE)
end
function c12009045.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) then
	   Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
	end
end
function c12009045.filter(c,e,tp,m,ft)
	if not c:IsCode(12009044) or bit.band(c:GetType(),0x81)~=0x81
		or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	local mg=m:Filter(Card.IsCanBeRitualMaterial,c,c)
	if ft>0 then
		return mg:CheckWithSumGreater(Card.GetRitualLevel,c:GetLevel(),c)
	else
		return mg:IsExists(c12009045.filter11,1,nil,tp,mg,c)
	end
end
function c12009045.filter11(c,tp,mg,rc)
	if c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5 then
		Duel.SetSelectedCard(c)
		return mg:CheckWithSumGreater(Card.GetRitualLevel,rc:GetLevel(),rc)
	else return false end
end
function c12009045.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp)
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		return ft>-1 and Duel.IsExistingMatchingCard(c12009045.filter,tp,LOCATION_HAND,0,1,nil,e,tp,mg,ft) and Duel.IsPlayerCanDraw(tp,1)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c12009045.activate(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetRitualMaterial(tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,c12009045.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp,mg,ft)
	local tc=tg:GetFirst()
	if tc then
		mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		local mat=nil
		if ft>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			mat=mg:SelectWithSumGreater(tp,Card.GetRitualLevel,tc:GetLevel(),tc)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			mat=mg:FilterSelect(tp,c12009045.filter11,1,1,nil,tp,mg,tc)
			Duel.SetSelectedCard(mat)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			local mat2=mg:SelectWithSumGreater(tp,Card.GetRitualLevel,tc:GetLevel(),tc)
			mat:Merge(mat2)
		end
		tc:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		if Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)~=0 then 
		   tc:CompleteProcedure()
		   Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end
