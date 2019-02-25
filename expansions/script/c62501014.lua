--陰義 電磁拔刀
function c62501014.initial_effect(c)
  local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c62501014.target)
	e1:SetOperation(c62501014.activate)
	c:RegisterEffect(e1)
   
end

function c62501014.filter(c,g)
	return c:IsCode(62501000)
end
function c62501014.desfilter(c,g)
	return c:IsType(TYPE_MONSTER)
end
function c62501014.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if  Duel.IsExistingMatchingCard(c62501014.filter,tp,LOCATION_MZONE,0,1,nil) then e:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE) end
	if chk==0 then return  Duel.IsExistingTarget(c62501014.desfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,nil)
		 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectTarget(tp,c62501014.desfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,1,0,0)
end
function c62501014.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc1=Duel.GetFirstTarget()
	local c=e:GetHandler()
	local cg=c:GetColumnGroup()
	if tc1:IsControler(tp) and tc1:IsRelateToEffect(e) and Duel.Destroy(tc1,REASON_EFFECT)>0 then
		 local g=Duel.GetMatchingGroup(c62501014.dessfilter,tp,0,LOCATION_ONFIELD,nil,cg)
		if g:GetCount()>0 then
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	end
end
function c62501014.dessfilter(c,g)
	return g:IsContains(c)
end