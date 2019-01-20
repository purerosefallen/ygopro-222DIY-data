--Ⅷ集团军 群龙女王
function c16001509.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,6,3,nil,nil,99)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(16001509,1))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,16001009)
	e1:SetCondition(c16001509.drcon)
	e1:SetTarget(c16001509.drtg)
	e1:SetOperation(c16001509.drop)
	c:RegisterEffect(e1)
	--Overlay
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(16001509,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,16011009)
	e2:SetCost(c16001509.cost)
	e2:SetTarget(c16001509.tg)
	e2:SetOperation(c16001509.op)
	c:RegisterEffect(e2)
	--limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_SUMMON)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTarget(c16001509.slimit)
	e3:SetTargetRange(0,1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	c:RegisterEffect(e4)
end
function c16001509.ovfilter(c,e)
	return c:IsAbleToChangeControler() and not c:IsImmuneToEffect(e)
end
function c16001509.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c16001509.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c16001509.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)~=0 then
		local c=e:GetHandler()
		local g=Duel.GetOperatedGroup()
		local tc=g:GetFirst()
		Duel.ConfirmCards(1-tp,tc)
		Duel.BreakEffect()
		if (tc:IsRace(RACE_DRAGON) and tc:IsType(TYPE_MONSTER)) or tc:IsSetCard(0x5c1) then
			if c:IsRelateToEffect(e) and Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>2 and not c:IsImmuneToEffect(e)
				and Duel.SelectYesNo(tp,aux.Stringid(16001509,2)) then
				local g=Duel.GetDecktopGroup(1-tp,3)
				local sg=g:Filter(c16001509.ovfilter,nil,e)
				if sg:GetCount()>0 then
					Duel.DisableShuffleCheck()
					Duel.Overlay(c,sg)
				end
			end
		end
		Duel.ShuffleHand(tp)
	end
end
function c16001509.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckRemoveOverlayCard(tp,1,0,1,REASON_COST) and Duel.GetOverlayCount(tp,1,1)>1 end
	Duel.RemoveOverlayCard(tp,1,0,1,1,REASON_COST)
end
function c16001509.filter(c)
	local og=Duel.GetOverlayGroup(tp,1,1)
	og:Sub(c:GetOverlayGroup())
	return c:IsType(TYPE_XYZ) and c:IsType(TYPE_MONSTER) and c:IsFaceup() and og:GetCount()>0
end
function c16001509.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c16001509.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c16001509.filter,tp,LOCATION_MZONE,0,1,nil) and Duel.CheckRemoveOverlayCard(tp,1,1,1,REASON_EFFECT) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c16001509.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c16001509.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
	local og=Duel.GetOverlayGroup(tp,1,1)
	og:Sub(tc:GetOverlayGroup())
	if og:GetCount()==0 then return end
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DEATTACHFROM)
	local mg=og:Select(tp,1,3,nil)
	local mat=mg:GetFirst()
	while mat do
		local oc=mat:GetOverlayTarget()
		Duel.RaiseSingleEvent(oc,EVENT_DETACH_MATERIAL,e,0,0,0,0)
		mat=mg:GetNext()
	end
	Duel.Overlay(tc,mg)
end
function c16001509.slimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLevelAbove(6)
end