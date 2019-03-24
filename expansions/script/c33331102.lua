--头钻小狐
if not pcall(function() require("expansions/script/c33331100") end) then require("script/c33331100") end
local m=33331102
local cm=_G["c"..m]
function cm.initial_effect(c)
	rslf.SpecialSummonFunction(c,m,cm.con,cm.op,cm.buff)
end
function cm.cfilter(c)
	return c:IsFaceup() and c:IsAbleToHandAsCost() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function cm.con(e,tp,c)
	return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_ONFIELD,0,1,c)
end
function cm.op(e,tp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local tg=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_ONFIELD,0,1,1,c)
	Duel.SendtoHand(tg,nil,REASON_EFFECT)
end
function cm.buff(c)
	local e1=rsef.SV_IMMUNE_EFFECT(c,cm.imval)
	local e2=rsef.I(c,{m,0},nil,"des",nil,LOCATION_MZONE,cm.descon,nil,cm.destg,cm.desop)
	return e1,e2
end
function cm.imval(e,re)
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end
function cm.descon(e,tp)
	return Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_ONFIELD,0,nil,TYPE_SPELL+TYPE_TRAP)<Duel.GetMatchingGroupCount(Card.IsType,tp,0,LOCATION_ONFIELD,nil,TYPE_SPELL+TYPE_TRAP)
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_ONFIELD,0,1,nil,TYPE_SPELL+TYPE_TRAP) and Duel.IsExistingMatchingCard(Card.IsType,tp,0,LOCATION_ONFIELD,1,nil,TYPE_SPELL+TYPE_TRAP) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,2,PLAYER_ALL,LOCATION_MZONE)
end
function cm.desop(e,tp)
	local g1=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_ONFIELD,0,nil,TYPE_SPELL+TYPE_TRAP)
	local g2=Duel.GetMatchingGroup(Card.IsType,tp,0,LOCATION_ONFIELD,nil,TYPE_SPELL+TYPE_TRAP)
	if #g1<=0 or #g2<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local dg1=g1:Select(tp,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local dg2=g2:Select(tp,1,1,nil)
	dg1:Merge(dg2)
	Duel.HintSelection(dg1)
	if Duel.Destroy(dg1,REASON_EFFECT)>0 and Duel.IsExistingMatchingCard(rslf.filter0,tp,LOCATION_EXTRA,0,1,nil) and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local tc=Duel.SelectMatchingCard(tp,rslf.filter0,tp,LOCATION_EXTRA,0,1,1,nil):GetFirst()
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end