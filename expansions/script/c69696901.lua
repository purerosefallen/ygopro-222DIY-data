--西高德
function c69696901.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_WATER),6,2)
	c:EnableReviveLimit()
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c69696901.con)
	e1:SetValue(600)
	c:RegisterEffect(e1)
	--move
	local e2=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(69696901,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetCountLimit(1)
	e2:SetCost(c69696901.cost)
	e2:SetTarget(c69696901.tg)
	e2:SetOperation(c69696901.op)
	c:RegisterEffect(e2)
end
function c69696901.con(e)
	return e:GetHandler():GetColumnGroupCount()==0
end
function c69696901.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c69696901.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_CONTROL)>0 end
end
function c69696901.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsControler(tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
		local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
		local nseq=math.log(s,2)
		Duel.MoveSequence(c,nseq)
		local g=c:GetColumnGroup()
		local cg=g:Filter(Card.IsType,nil,TYPE_LINK)
		if g:GetCount()>0 then
			local seq=0
			local tc=cg:GetFirst()
			while tc do 
			   if tc:IsControler(tp) then
			   seq=bit.bor(seq,bit.rshift(tc:GetLinkedZone(),16))
			   else seq=bit.bor(seq,bit.lshift(tc:GetLinkedZone(),16)) end
			   tc=cg:GetNext()
			end
			e:SetLabel(seq)
			Duel.BreakEffect()
			if Duel.SendtoDeck(g,nil,2,REASON_EFFECT)~=0 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_DISABLE_FIELD)
			e1:SetRange(LOCATION_MZONE)
			e1:SetLabel(e:GetLabel())
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetOperation(c69696901.disop)
			e:GetHandler():RegisterEffect(e1)
			end
		end
	end
end
function c69696901.disop(e,tp)
	return e:GetLabel()
end

