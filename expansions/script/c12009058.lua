--七色的歌姬 蕾恩缇娅
function c12009058.initial_effect(c)
	c:SetSPSummonOnce(12009058)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(12009058,2))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetTarget(c12009058.drtg)
	e3:SetOperation(c12009058.drop)
	c:RegisterEffect(e3)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_TOGRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetHintTiming(0,0x1e0)
	e2:SetTarget(c12009058.rmtg)
	e2:SetOperation(c12009058.rmop)
	c:RegisterEffect(e2)
end
function c12009058.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local cg=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND+LOCATION_ONFIELD)
	local sg=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	local cc=cg-sg
	if chk==0 then return cg>sg and Duel.IsPlayerCanDraw(tp,cc) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(cc)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,cc)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,tp,cc-1)
end
function c12009058.drop(e,tp,eg,ep,ev,re,r,rp)
	local cg=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND+LOCATION_ONFIELD)
	local sg=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	local cc=cg-sg
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)==cc then
		local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,p,LOCATION_HAND,0,nil)
		if g:GetCount()==0 then return end
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
		local sg=g:Select(p,cc-1,cc-1,nil)
		Duel.SendtoDeck(sg,nil,0,REASON_EFFECT)
		Duel.SortDecktop(p,p,cc-1)
		for i=1,cc-1 do
			local mg=Duel.GetDecktopGroup(p,1)
			Duel.MoveSequence(mg:GetFirst(),1)
		end
	end
end
function c12009058.filter3(c)
	return c:IsType(TYPE_MONSTER) and not c:IsCode(12009058) and c:IsAbleToGrave()
end
function c12009058.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil)
		and Duel.IsExistingMatchingCard(c12009058.filter3,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,g,1,0,0)
end
function c12009058.rmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,c12009058.filter3,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
	if g1:GetCount()>0 then
		if Duel.SendtoGrave(g1,REASON_EFFECT) then Duel.BreakEffect()
			local tc=Duel.GetFirstTarget()
			local tc2=g1:GetFirst()
			local atk=tc2:GetAttack()
			local def=tc2:GetDefense()
			if tc:IsRelateToEffect(e) and tc:IsFaceup() then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_ATTACK)
				e1:SetValue(-atk)
				e1:SetReset(RESET_EVENT+0x1fe0000)
				tc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(e:GetHandler())
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_UPDATE_DEFENSE)
				e2:SetValue(-atk)
				e2:SetReset(RESET_EVENT+0x1fe0000)
				tc:RegisterEffect(e2)
			end
		end
	end
end