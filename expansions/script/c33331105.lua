--榛子小狐
if not pcall(function() require("expansions/script/c33331100") end) then require("script/c33331100") end
local m=33331105
local cm=_G["c"..m]
function cm.initial_effect(c)
	rslf.SpecialSummonFunction(c,m,cm.con,cm.op,cm.buff)
end
function cm.con(e,tp)
	return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_HAND,0,1,nil) and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
end
function cm.cfilter(c)
	return rslf.filter0(c) and c:IsType(TYPE_NORMAL) and not c:IsForbidden()
end
function cm.op(e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_HAND,0,1,1,nil):GetFirst()
	Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
end
function cm.buff(c)
	local e1=rsef.FV_LIMIT_PLAYER(c,"rm",nil,cm.tg,{1,0})
	local e2=rsef.FV_LIMIT(c,"dis",nil,cm.distg,{0,LOCATION_EXTRA },cm.discon)
	local e3=rsef.FV_LIMIT_PLAYER(c,"sp",nil,cm.distg,{0,1},cm.discon)
	return e1,e2,e3
end
function cm.tg(e,c)
	return c==e:GetHandler()
end
function cm.distg(e,c)
	return c:IsFaceup() and c:IsLocation(LOCATION_EXTRA) and c:IsControler(1-e:GetHandlerPlayer())
end
function cm.discon(e,tp)
	return Duel.GetMatchingGroupCount(Card.IsFaceup,tp,LOCATION_EXTRA,0,nil)<Duel.GetMatchingGroupCount(Card.IsFaceup,tp,0,LOCATION_EXTRA,nil)
end
